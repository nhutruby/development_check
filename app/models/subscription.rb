class Subscription
  FREE_PLAN_HANDLE = 'free_plan'

  PLANS = [
    {
      :product_id     => FREE_PLAN_HANDLE,
      :name           => 'Free',
      :handle         => FREE_PLAN_HANDLE,
      :price_in_cents => 0
    },

    {
      :product_id     => '12822',
      :name           => 'Basic',
      :handle         => 's_15',
      :price_in_cents => 50 * 100
    },

    {
      :product_id     => '12823',
      :name           => 'Premium',
      :handle         => 's_75',
      :price_in_cents => 75 * 100
    },

    {
      :product_id     => '18071',
      :name           => 'Unlimited',
      :handle         => 's_150',
      :price_in_cents => 150 * 100
    }
  ]

  class << self
    def free
      Chargify::Product.find_by_handle(FREE_PLAN_HANDLE)
    end

    def all_products
      PLANS.map { |plan| Hashie::Mash.new(plan) }
    end

    def product_by_handle(handle)
      current = PLANS.select { |plan| handle == plan[:handle] }
      Hashie::Mash.new(current.first) if current.first
    end
    
    def product_from_id(id)
      product = PLANS.find { |plan| id == plan[:product_id] }
      Hashie::Mash.new(product) if product
    end
  end

  def state
    "active"
  end

  def reload
    self
  end

  def product
    free = YAML.load_file "#{RAILS_ROOT}/config/free_subscription_credits.yml"
    Hashie::Mash.new({
      :name           => "Free",
      :handle         => FREE_PLAN_HANDLE,
      :price_in_cents => 0,
      :credits        => free['credits'].to_i,
      :description    => free['description'].to_s
    })
  end

  # def customer
  #   Hashie::Mash.new({
  #     :id => 0,
  #     :first_name => "Free",
  #     :last_name => "Free",
  #     :handle => FREE_PLAN_HANDLE
  #   })
  # end

  def transactions
    []
  end

  def payment_profile
    Hashie::Mash.new({
      :first_name         => "",
      :last_name          => "",
      :masked_card_number => "",
      :card_type          => "",
      :expiration_month   => "",
      :expiration_year    => ""
    })
  end
end
