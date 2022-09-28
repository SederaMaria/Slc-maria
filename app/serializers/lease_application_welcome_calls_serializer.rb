class LeaseApplicationWelcomeCallsSerializer < ApplicationSerializer
    attributes :id, :status, :type, :result, :representative, :date_and_time

    def status
        self&.object&.welcome_call_status&.description
    end

    def type
        self&.object&.welcome_call_type&.description
    end

    def result
        self&.object&.welcome_call_result&.description
    end 

    def representative
        "#{self&.object&.admin_user&.first_name} #{self&.object&.admin_user&.last_name}"
    end 

    def date_and_time
        self&.object&.created_at.strftime('%B %-d %Y at %r %Z')
    end 

end