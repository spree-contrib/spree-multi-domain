Spree::BaseController.class_eval do

  before_action { prepend_view_path "app/views/#{current_store.code}" }

end
