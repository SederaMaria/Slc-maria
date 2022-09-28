module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

  protected

    def find_verified_user
      if current_user = env['warden'].user(:dealer) || env['warden'].user(:admin_user)
        current_user
      else
        reject_unauthorized_connection
      end
    # NOTE: Use `catch` instead?
    rescue UncaughtThrowError => e
      # Specifically for warden
      if e.message == 'uncaught throw :warden'
        reject_unauthorized_connection
      else
        # We want to re-raise if its not a warden
        raise e
      end
    end
  end
end
