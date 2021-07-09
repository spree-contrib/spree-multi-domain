module SpreeMultiDomain
  module TaxonDecorator
    def self.prepended(base)
      base.scope :by_store, ->(store_id) { joins(:taxonomy).merge(Spree::Taxonomy.by_store(store_id)) }
      base.extend ClassMethods
    end

    module ClassMethods
      def find_by_store_id_and_permalink!(store_id, permalink)
        by_store(store_id).where(permalink: permalink).first!
      end
    end
  end
end

::Spree::Taxon.prepend(SpreeMultiDomain::TaxonDecorator)
