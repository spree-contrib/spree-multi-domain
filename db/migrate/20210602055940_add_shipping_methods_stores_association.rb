class AddShippingMethodsStoresAssociation < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_shipping_methods_stores, id: false do |t|
      t.belongs_to :shipping_method
      t.belongs_to :store
    end
  end
end
