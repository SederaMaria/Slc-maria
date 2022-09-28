ActiveAdmin.register_page "Sidekiq", namespace: :admins do
    menu parent: "Administration", url: "/sidekiq", if: proc{ current_admin_user.is_administrator? }, html_options: { target: '_blank' }
end