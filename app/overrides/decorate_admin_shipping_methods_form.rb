Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'multi_domain_admin_shipping_method_stores_form',
  insert_after: "[data-hook='admin_shipping_method_form_display_field']",
  partial: 'spree/admin/shipping_methods/stores',
  disabled: false
)
