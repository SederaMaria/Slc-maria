ActiveAdmin.register_page "Emails", namespace: :admins do
  menu parent: "Administration", url: "#{ENV['LOS_UI_URL']}/administration/email-templates", if: proc{ current_admin_user.is_administrator? }
end