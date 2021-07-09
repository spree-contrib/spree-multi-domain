module Spree
  module Admin
    module ShippingMethodsControllerDecorator
      def self.prepended(base)
        base.before_action :load_stores, only: [:edit, :update]
      end

      private

      def load_stores
        @stores = Spree::Store.all
      end
    end
  end
end

::Spree::Admin::ShippingMethodsController.prepend(Spree::Admin::ShippingMethodsControllerDecorator)
