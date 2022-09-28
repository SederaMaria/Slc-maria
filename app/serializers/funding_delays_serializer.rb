class FundingDelaysSerializer < ApplicationSerializer
    attributes :id , :status, :notes, :reasons, :applied_on

    def reasons
        self.object.funding_delay_reason&.reason
    end

    def applied_on
        self.object.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %-d %Y at %r %Z')
    end
  end