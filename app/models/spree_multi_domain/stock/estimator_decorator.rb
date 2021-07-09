module SpreeMultiDomain
  module Stock
    module EstimatorDecorator

      def shipping_methods(package, display_filter)
        package.shipping_methods.select do |ship_method|
          calculator = ship_method.calculator

          ship_method.available_to_display?(display_filter) &&
            ship_method.available_for_store?(order.store) &&
            ship_method.include?(order.ship_address) &&
            calculator.available?(package) &&
            (calculator.preferences[:currency].blank? ||
             calculator.preferences[:currency] == currency)
        end
      end


    end
  end
end

::Spree::Stock::Estimator.prepend(SpreeMultiDomain::Stock::EstimatorDecorator)
