module SimpleAudit
  module Auditor
    extend ::ActiveSupport::Concern
    included do
      before_action :set_auditor
    end

    def set_auditor
      user = get_identity
      return if user.nil?
      as_user(user)
    end

    def as_user(user)
      store[:auditor] = {
        user_id: user.id,
        user_type: user.class.to_s
      }
    end

    # Safely traverse thru multiple controller identity helpers
    def get_identity
      # Identity helpers defined by ActiveAdmin
      dealer = defined?(current_dealer) ? current_dealer : nil
      admin = defined?(current_admin_user) ? current_admin_user : nil

      # Identity helper defined by Api::V1::ApiController
      api_user = defined?(current_user) ? current_user : nil

      return dealer if dealer
      return admin if admin
      return api_user if api_user
    end

    def store
      Store.cache
    end
  end
end
