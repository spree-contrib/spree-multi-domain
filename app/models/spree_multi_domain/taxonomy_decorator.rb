module SpreeMultiDomain
  module TaxonomyDecorator
    def self.prepended(base)
      base.belongs_to :store

      base.scope :by_store, ->(store_id) { where(store_id: store_id) }
    end
  end
end

::Spree::Taxonomy.prepend(SpreeMultiDomain::TaxonomyDecorator)
