ActiveAdmin.register_page "Settings", namespace: :admins do
  menu parent: "Administration", url: "#{ENV['LOS_UI_URL']}/administration/settings", if: proc{ current_admin_user.is_administrator? }
end