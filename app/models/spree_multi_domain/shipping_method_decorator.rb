module SpreeMultiDomain
  module ShippingMethodDecorator
    def self.prepended(base)
      base.has_and_belongs_to_many :stores
    end

    def available_for_store?(store)
      return true if self.stores.blank?

      store_ids.include?(store.id)
    end

  end
end

::Spree::ShippingMethod.prepend(SpreeMultiDomain::ShippingMethodDecorator)
