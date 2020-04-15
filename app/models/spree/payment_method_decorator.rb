module Spree::PaymentMethodDecorator
  def self.prepended(base)
    base.has_many :store_payment_methods
    base.has_many :stores, through: :store_payment_methods
  end

  def self.available(display_on = 'both', store = nil)
    result = all.select do |payment_method|
      payment_method.active &&
        (store.nil? || store.payment_methods.empty? || store.payment_methods.include?(payment_method)) &&
        (payment_method.display_on.blank? || payment_method.display_on.in?(['both', display_on.to_s]))
    end
  end
end

Spree::PaymentMethod.prepend Spree::PaymentMethodDecorator
