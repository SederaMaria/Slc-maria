ActiveAdmin.register_page "Control Panel", namespace: :admins do
  menu parent: "Administration", url: "#{ENV['LOS_UI_URL']}/administration/control-panel", if: proc{ current_admin_user.is_administrator? }
end