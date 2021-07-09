module SpreeMultiDomain
  module StoreDecorator
    def self.prepended(base)
      base.has_many :store_products, class_name: 'Spree::StoreProduct', dependent: :destroy
      base.has_many :products, through: :store_products, class_name: 'Spree::Product'
      base.has_many :taxonomies
      base.has_and_belongs_to_many :promotion_rules, class_name: 'Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'
      base.has_many :shipping_methods, class_name: 'Spree::ShippingMethod'
    end
  end
end

::Spree::Store.prepend(SpreeMultiDomain::StoreDecorator)
