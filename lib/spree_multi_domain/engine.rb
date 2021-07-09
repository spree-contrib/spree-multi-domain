module SpreeMultiDomain
  class Engine < Rails::Engine
    engine_name 'spree_multi_domain'

    config.autoload_paths += %W[#{config.root}/lib]

    DEFAULT_LAYOUT = 'spree/layouts/spree_application'.freeze
    @current_store_code = nil

    def self.activate
      %w[app lib].each do |dir|
        Dir.glob(File.join(File.dirname(__FILE__), "../../#{dir}/**/*_decorator*.rb")).sort.each do |c|
          require_dependency(c)
        end
      end

      Spree::Config.searcher_class ||= Spree::Search::MultiDomain
      ApplicationController.include SpreeMultiDomain::MultiDomainHelpers
    end

    config.to_prepare(&method(:activate).to_proc)

    initializer 'templates with dynamic layouts' do
      ActionView::TemplateRenderer.prepend(
        Module.new do
          def resolve_layout(layout, keys, formats)
            details = @details.dup
            details[:formats] = formats

            case layout
            when String
              begin
                if layout.start_with?('/')
                  ActiveSupport::Deprecation.warn 'Rendering layouts from an absolute path is deprecated.'
                  @lookup_context.with_fallbacks.find_template(layout, nil, false, [], details)
                else
                  @lookup_context.find_template(layout, nil, false, [], details)
                end
              rescue ActionView::MissingTemplate
                if @current_store_code
                  layout.slice!("/#{@current_store_code}")
                  @lookup_context.with_fallbacks.find_template(layout, nil, false, [], details)
                else
                  @lookup_context.with_fallbacks.find_template(DEFAULT_LAYOUT, nil, false, [], details)
                end
              end
            when Proc
              resolve_layout(layout.call(@lookup_context, formats), keys, formats)
            else
              layout
            end
          end

          def render_template(view, template, layout_name, locals)
            @current_store_code = if view.respond_to?(:current_store)
                                    view.current_store.code
                                  else
                                    Spree::Store.default.code
                                  end
            store_layout = if layout_name.nil?
                             nil
                           elsif layout_name.is_a?(String)
                             layout_name.gsub('layouts/', "layouts/#{@current_store_code}/")
                           else
                             begin
                               layout_name.call.try(:gsub, 'layouts/', "layouts/#{@current_store_code}/")
                             rescue NoMethodError
                               layout_name
                             end
                           end

            super(view, template, store_layout, locals)
          end
        end
      )
    end

    initializer 'spree.promo.register.promotions.rules' do |app|
      app.config.spree.promotions.rules << Spree::Promotion::Rules::Store
    end
  end
end
