module Spree
  module Api
    module ProductsHelper
      def get_taxonomies
        @taxonomies ||= current_store.present? ? Spree::Taxonomy.by_store(current_store) : Spree::Taxonomy
        @taxonomies = @taxonomies.includes(root: :children)
        @taxonomies
      end
    end
  end
end
