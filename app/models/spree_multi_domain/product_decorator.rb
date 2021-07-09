module SpreeMultiDomain
  module ProductDecorator
    def self.prepended(base)
      base.has_many :store_products, class_name: 'Spree::StoreProduct', dependent: :destroy
      base.has_many :stores, through: :store_products, class_name: 'Spree::Store'

      base.scope :by_store, ->(store) { joins(:stores).where(spree_products_stores: { store_id: store.id }) }
    end
  end
end

::Spree::Product.prepend(SpreeMultiDomain::ProductDecorator)
