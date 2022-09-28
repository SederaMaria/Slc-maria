require 'sidekiq/web'

def admin_users_configuration
  root_config = ActiveAdmin::Devise.config.merge({ path: '/admins' })
  root_config[:controllers].merge!({ password_expired: 'active_admin/devise/password_expired' })
  root_config
end

def dealers_configuration
  root_config = ActiveAdmin::Devise.config.merge({ path: '/dealers' })
  root_config[:controllers].merge!({ password_expired: 'active_admin/devise/password_expired' })
  root_config
end

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :insurance_companies
  get '/admins/login' => redirect((ENV['LOS_UI_URL']).to_s)

  mount ActionCable.server => '/cable'

  devise_for :admin_users, admin_users_configuration
  devise_for :dealers, dealers_configuration
  ActiveAdmin.routes(self)

  get '/auth/:token' => 'application#auto_login'
  # constraints(:host => "dealer.speedleasing.com") do
  #   root to: redirect("https://dealer.speedleasing.com/dealers")
  # end

  # constraints(:host => "admin.speedleasing.com") do
  #   root to: redirect("https://admin.speedleasing.com/admins")
  # end
  post '/admins/lease_application_attachments/:id/dealership_mail',
       to: 'admins/lease_application_attachments/dealership_mails#create', as: 'mail_attachment_to_dealership'

  resources :notifications, only: [:index] do
    member do
      post 'mark-as-read'
    end
    collection do
      post 'mark-all-read'
    end
  end

  get '/lease_calculators/credit_tier_select', to: 'lease_calculators#credit_tier_select'

  constraints format: :json do
    resources :lease_calculators, only: [:create]
    resources :tax_jurisdictions, only: [:index]
    resources :georgia_tax_guides, path: 'georgia-tax-guides', only: [:index]
    resources :credit_tiers, only: [] do
      collection do
        get 'model_group_options'
      end
    end
  end

  root to: 'home#index'
  Sidekiq::Web.disable :sessions
  if Rails.env.production? || Rails.env.staging?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                                  ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_AUTH_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_AUTH_PASSWORD']))
    end
  end
  mount Sidekiq::Web => '/sidekiq'


  namespace :api do
    namespace :v1 do
      # scope :constraints => AllowWhitelistConstraint.new do
      as :admin_user do
        post '/sign-in' => 'sessions#create'
        post '/sign-out' => 'sessions#destroy'
        post '/logout_all_dealears' => 'sessions#logout_all_dealears'
        post '/validate-token' => 'sessions#validate_token'
      end
      resources :employment_status, path: 'employment-status', only: [:index], format: :json
      resources :states, only: [:index], format: :json
      resources :address, only: %i[index show], format: :json do
        collection do
          get :find_city
          get 'city-details'
        end
      end

      resources :lease_applications do
        get :application, on: :collection
        get :status, on: :collection
        get :dealership_id, on: :collection
        get :manufacturer, on: :collection
        get :asset_model, on: :collection
        get :vendor, on: :collection
        get :payment_schedule, on: :collection
        get :disbursement_date, on: :collection
        get :search, on: :collection
        get 'details' => 'lease_applications#get_details', on: :collection
        put 'details' => 'lease_applications#update_details', on: :collection
        post :create_welcome_call, on: :collection
        post :create_reference, on: :collection
        post :create_funding_delay, on: :collection
        get 'request-review', on: :collection
        get 'approve-underwritting', on: :collection
        get 'repull-lessee-credit', on: :collection
        get 'repull-datax', on: :collection
        get 'generate-lease-package', on: :collection
        get 'resend-funding-request', on: :collection
        put 'welcome-call-due-date', on: :collection
        post 'repull-colessee-credit', on: :collection
        put 'swap-lessee', on: :collection
        post 'resend-credit-decision', on: :collection
        post 'generate-credit-decision-notifications', on: :collection
        put 'remove-colessee', on: :collection
        put 'expire-lease-application', on: :collection
        put 'unexpire-lease-application', on: :collection
        post 'repull-credit-reports', on: :collection
        put 'funding-approval-checklist', on: :collection
      end
      resources :lease_applications, path: '/public-application', only: [:create]
      resources :email_templates, path: '/email-templates', only: [] do
        get 'get-details', on: :collection
        put '/:name' => 'email_templates#update', on: :collection
      end
      resources :makes, only: [:index]
      resources :bike_information, path: 'bike-information', only: [] do
        collection do
          get 'makes-name-options'
          get 'years-options'
          get 'models-options'
          get 'credit-tier-options'
        end
      end
      resources :funding_delay_reasons, only: [:index]
      resources :model_groups, path: '/model-groups', only: [:index] do
        collection do
          # put :sort_order
          put 'sort-order'
        end
      end
      resources :admin_users, path: '/admin-users', only: %i[show update index create] do
        collection do
          put 'expire-password/:id', to: 'admin_users#expire_password'
          put 'expire-session/:id', to: 'admin_users#expire_session'
          get 'get-pinned-tabs'
          put 'lock-user/:id', to: 'admin_users#lock_user'
          get 'need-change-password'
          put 'unlock-user/:id', to: 'admin_users#unlock_user'
          put 'update-pinned-tabs'
        end
      end

      resources :application_settings, path: '/application-settings', only: %i[index update]
      resources :model_years, only: [:index] do
        collection do
          get 'select-options'
        end
      end

      resources :banner, only: %i[index update]

      resources :welcome_call_types, path: 'welcome-call-types', only: %i[index create] do
        collection do
          # put :update_sort_order
          # put :update_active_type
          # put :update_description
          put 'update-sort-order'
          put 'update-active-type'
          put 'update-description'
        end
      end
      resources :welcome_call_results, path: 'welcome-call-results', only: %i[index create] do
        collection do
          put 'update-sort-order'
          put 'update-active-result'
          put 'update-description'
          # put :update_sort_order
          # put :update_active_result
          # put :update_description
        end
      end
      resources :mail_carriers, path: 'mail-carriers', only: %i[index create] do
        collection do
          put 'update-sort-order'
          put 'update-active-mail-carriers'
          put 'update-description'
        end
      end
      resources :stipulations, only: [:index]
      resources :lease_application_stipulations, path: 'lease-application-stipulations', only: %i[update create]
      resources :security_roles, path: 'security-roles', only: [] do
        collection do
          get 'can-see-welcome-call-dashboard'
          get 'security-roles-options'
        end
      end
      resources :remit_to_dealer_calculations, only: [:index]
      resources :dealer_representatives, only: [:index] do
        collection do
          get :active
        end
      end
      resources :dealerships, only: %i[index show update create] do
        collection do
          post :search, action: 'index'
          get 'dealerships-options'
          # get 'approval'
          post 'approval', action: 'approval'
          post 'upload-attachments'
          get 'generate-dealer-agreement'
        end
      end
      resources :common_application_settings, only: [:index] do
        collection do
          put :update_scheduling_day
        end
      end
      resources :lease_application_pending_calls, path: 'lease-application-pending-calls', only: %i[index show]
      resources :notifications, only: [:index] do
        collection do
          put :mark_as_read
          put :mark_all_read
          get :get_all_notifications
        end
      end
      resources :references, only: [:destroy]
      resources :comments, only: %i[create destroy] do
        collection do
          post 'x/:resource_name/:resource_id', to: 'comments#resource_create_comment'
        end
      end
      resources :adjusted_capitalized_cost_ranges, only: %i[index update]
      resources :lease_application_requests, only: [] do
        collection do
          get 'new_prenote'
        end
      end
      resources :online_funding_approval_checklists, only: [] do
        collection do
          get 'save_pdf'
          get 'download_pdf'
        end
      end
      resources :lease_application_reports, only: [] do
        collection do
          get 'export_csv'
          get 'export_poa'
          post 'export_access_db'
          post 'export_funding_delays'
        end
      end
      resources :credit_tiers, only: %i[index update]
      resources :lease_application_attachments, only: [:update, :index, :create, :destroy] do
        collection do
          put 'toggle-visibility'
          post 'mail-attachment-to-dealership'
        end
      end
      resources :incoming_emails, only: [] do
        collection do
          post 'validate'
          post 'add-attachments'
          get 'threat-found'
        end
      end

      resources :vin_verification, only: [] do
        collection do
          get 'verify-vin'
        end
      end

      resources :vehicle_inventory, path: 'vehicle-inventory' do
        collection do
          post 'upload-image'
          get 'delete-image'
          get 'nada-value-history'
        end
      end
      resources :lease_management_systems, path: 'lease-management-systems', only: [:update] do
        collection do
          get 'get-details'
        end
      end
      resources :inventory_status, path: 'inventory-status', only: [:index]
      resources :lease_application_blackbox_requests, path: 'lease-application-blackbox-requests', only: [:show]
      resources :workflow_setting_values, path: 'workflow-setting-values', only: %i[index create]
      resources :lease_application_gps_units, path: 'lease-application-gps-units'
      resources :income_verifications, path: 'income-verifications', only: %i[create update destroy]
      resources :credit_reports, path: 'credit-reports', only: [] do
        get :details
      end
      resources :online_verification_call_checklists, path: 'online-verification-call-checklists',
                                                      only: %i[show update] do
        post :generate_pdf
      end
      resources :lease_application_payment_limits, path: 'lease-application-payment-limits', only: %i[update] do
        put :reset
      end

      resources :dealers, only: [] do
        collection do
          post 'applications' => 'dealers_lease_applications#applications'
          get 'get-details' => 'dealers_lease_applications#get_details'
          put 'update-details' => 'dealers_lease_applications#update_details'
          get 'applications/filter-options' => 'dealers_lease_applications#filter_options'
          get '/:id/banking-information' => 'dealer_dealership#banking_information'
          put '/:id/banking-information' => 'dealer_dealership#update_banking_information'
          get 'applications/:id/references' => 'dealers_lease_application_references#index'
          post 'applications/:id/references' => 'dealers_lease_application_references#create'
          get 'applications/:id' => 'dealers_lease_applications#submit_to_speedleasing'
          post 'applications/:id/archive' => 'dealers_lease_applications#archive_application'
        end
      end

      resources :calculators, only: [:new, :create] do
        collection do
          get 'active-state-select-option' => 'calculators#active_state_select_option'
          get 'tax-jurisdiction-select-option' => 'calculators#tax_jurisdiction_select_option'
        end
      end
    end
  end

  get '*unmatched_route', to: redirect('https://speedleasing.com/')
end
