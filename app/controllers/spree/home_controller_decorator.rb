module Spree::HomeControllerDecorator
  def index
    @searcher = build_searcher(params)
    @products = @searcher.retrieve_products
    @taxonomies = get_taxonomies
  end
end

Spree::HomeController.prepend Spree::HomeControllerDecorator
