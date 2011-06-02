require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Organization do

  context "creating a new Organization" do
    before(:each) do
      @user = Factory(:user)
      mock_chargify_service
    end

    it "should success given valid attributes" do
      organization = valid_organization
      organization.save.should be_true
      organization.should be_valid
    end
 
    it "should require a name" do
      organization = invalid_organization
      organization.save.should_not be_true
      organization.should_not be_valid
    end

    it "should create a free chargify subscription" do
      organization = valid_organization
      organization.create_and_subscribe
      organization.subscription.should_not be_nil
      organization.subscription.product.handle.should == Subscription::FREE_PLAN_HANDLE
    end

    it "should create a chargify customer" do
      organization = valid_organization
      organization.create_and_subscribe
      organization.subscription.should_not be_nil
      organization.customer.email.should == @user.email
    end

    it "should not create a chargify customer twice" do
      organization = valid_organization
      organization.create_and_subscribe
      organization.subscription.should_not be_nil

      organization2 = valid_organization
      organization2.create_and_subscribe
      organization2.subscription.should_not be_nil

      organization.customer.should == organization2.customer
    end

    it "should store the chargify customer subscription state" do
      organization = valid_organization
      Chargify::Subscription.stubs(:find).returns(nil)
      organization.create_and_subscribe
      organization.should be_valid
      organization.stubs(:subscription).returns(chargify_subscription_mock)
      organization.subscription.should_not be_nil
      organization.subscription_state.should == "active"
    end
  end

  context "destroying an Organization" do
    before(:each) do
      @user = Factory(:user)
      mock_chargify_service
    end

    it "should destroy the associated chargify subscription" do
      Chargify::Subscription.expects(:cancellation_message=).times(1)
      Chargify::Subscription.expects(:save).times(1)
      Chargify::Subscription.expects(:cancel).times(1)
      organization = valid_organization
      organization.create_and_subscribe
      organization.subscription.should_not be_nil
      organization.customer.email.should == @user.email
      organization.destroy
    end
  end

  private

  def valid_organization
    Organization.new({:name => "My Organization", :creator_id => @user.id})
  end

  def invalid_organization
    Organization.new
  end

  def mock_chargify_service
    Chargify::Subscription.stubs(:new).returns(chargify_subscription_mock)
    Chargify::Subscription.stubs(:find).returns(chargify_subscription_mock)
    Chargify::Customer.stubs(:find).returns(chargify_customer_mock)
  end

  def chargify_subscription_mock
    obj = mock("Chargify::Subscription", :save => true, :id => "323232")
    obj.stubs(:customer_attributes=).returns(nil)
    obj.stubs(:product).returns(chargify_product_mock)
    obj.stubs(:customer).returns(chargify_customer_mock)
    obj.stubs(:cancellation_message=).returns(nil)
    obj.stubs(:cancel).returns(true)
    obj.stubs(:state).returns("active")
    obj
  end

  def chargify_product_mock
    mock("Chargify::Product", :handle => Subscription::FREE_PLAN_HANDLE)
  end

  def chargify_customer_mock
    mock("Chargify::Customer", :email => @user.email, :id => "212121")
  end
end
