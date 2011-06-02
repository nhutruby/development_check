class ChargifyController < ApplicationController
  skip_authorization_check
    
  def update_subscription
    begin
      #@subscription_ids = [270021] # this is for testing 
      @subscription_ids = (params['_json'] || []).uniq.compact
      @subscription_ids.each do |subscription_id|
        subscription = Chargify::Subscription.find(subscription_id)
        #logger.info subscription.inspect
        @organization = Organization.find_by_subscription_id(subscription.id)
        next unless @organization

        @organization.selected_plan = subscription.product.handle
        @organization.subscription_state = subscription.state
      
        #logger.info "SELECTED PLAN FROM CHARGIFY: #{subscription.product.handle}"
        @organization.save(:validate => false)

        notify_user(@organization)
      end
    rescue Exception => e
      logger.error e.inspect
      render :text => 'error', :status => 500
      return
    end
    render :text => 'ok', :status => 200
  end

  private

  def notify_user(organization)
    user = organization.primary_contact
    case organization.subscription_state
    when "past_due"
      user.notes.create(:is_sysmessage => true, :subject => "Your account is past due.", :body => "Your subscription for  '#{organization.name}' has been downgraded to Free due to past due payment.  To restore your account, please update your billing information.")
    when "canceled"
      user.notes.create(:is_sysmessage => true, :subject => "Your subscription has been canceled.", :body => "Your subscription for  '#{organization.name}' has been cancelled due to invalid payment information.  To restore your account, please update your billing information.")
    end
  end
end