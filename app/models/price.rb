class Price < ActiveRecord::Base

  belongs_to :priceable, :polymorphic => true
  attr_accessor :currency_field, :user

  composed_of :price_low,
    :class_name => "Money",
    :mapping => [%w(price_low_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
          
  composed_of :price_high,
    :class_name => "Money",
    :mapping => [%w(price_high_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  composed_of :retail_low,
    :class_name => "Money",
    :mapping => [%w(retail_low_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  composed_of :retail_high,
    :class_name => "Money",
    :mapping => [%w(retail_high_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  after_validation :update_changelog
  before_save :set_pricing_type
  
  def set_pricing_type
    if self.pricing_type == "free"
      self.price_low = 0
      self.price_high = 0
      self.retail_low = 0
      self.retail_high = 0
    end
  end

  def update_changelog
    if (self.changed? && self.pricing_type != "free" && self.pricing_type != "contact") or self.changelog.blank?
      price_low = Money.new(self.price_low_cents, self.currency).format(:with_currency => true)
      price_high = Money.new(self.price_high_cents, self.currency).format(:with_currency => true)
      retail_low = Money.new(self.retail_low_cents, self.currency).format(:with_currency => true)
      retail_high = Money.new(self.retail_high_cents, self.currency).format(:with_currency => true)
      change = "|#{price_low}|#{price_high}|#{retail_low}|#{retail_high}|#{Time.now.to_s(:long)}|#{user}|"
      if !self.changelog.blank?
        self.changelog = self.changelog + "\r\n" + change
      else
        self.changelog = 'table{border:1px solid black}.
{background:#ddd}. |_\2=. Price|_\2=. Retail Value|_/2=. Changed At |_/2=. By|
{background:#ddd}. |_. Low|_. High|_. Low|_. High|' + "\r\n" +change
      end
    elsif self.changed? && self.pricing_type == "free"
      change = '|\4=. no cost |' + " #{Time.now.to_s(:long)} | #{user}|"
      if !self.changelog.blank?
        self.changelog = self.changelog + "\r\n" + change
      else
        self.changelog = 'table{border:1px solid black}.
{background:#ddd}. |_\2=. Price|_\2=. Retail Value|_/2=. Changed At |_/2=. By|
{background:#ddd}. |_. Low|_. High|_. Low|_. High|' + "\r\n" + change
      end
    elsif self.changed? && self.pricing_type == "contact"
      change = '|\4=. contact us |' + " #{Time.now.to_s(:long)} | #{user}|"
      if !self.changelog.blank?
        self.changelog = self.changelog + "\r\n" + change
      else
        self.changelog = 'table{border:1px solid black}.
{background:#ddd}. |_\2=. Price|_\2=. Retail Value|_/2=. Changed At |_/2=. By|
{background:#ddd}. |_. Low|_. High|_. Low|_. High|' + "\r\n" + change
      end
    end
  end
end
