class DealerSecurityRole < ApplicationRecord
    belongs_to :dealer
    belongs_to :security_role
end
