class DealershipApprovalEventSerializer < ApplicationSerializer
    attributes :id, :event, :team_member, :created_at, :comments


    def event
        object&.approved ? 'Approved' : 'Unapproved'
    end

    def team_member
        object&.admin_user&.full_name
    end

    def created_at 
        object&.created_at.strftime('%B %-d %Y at %r %Z')
    end

end