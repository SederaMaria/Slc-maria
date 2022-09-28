module Api
    module V1
        class FundingDelayReasonsController < Api::V1::ApiController
            def index
                @funding_delay_reasons = FundingDelayReason.all.order(:reason)
            end
        end
    end
end