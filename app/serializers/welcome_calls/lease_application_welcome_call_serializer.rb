module WelcomeCalls
  class LeaseApplicationWelcomeCallSerializer < ApplicationSerializer
    attributes :id, :status, :type, :result, :representative, :date_and_time, :notes, :resource_type, :resource_id
    
    has_many :comments, class_name: 'ActiveAdminComment', serializer: CommentSerializer
    
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
        self&.object&.created_at.strftime('%e %b %Y %H:%M:%S%p')
    end

    def resource_type
      'LeaseApplicationWelcomeCall'
    end

    def resource_id
      self&.object&.id
    end

  end
end