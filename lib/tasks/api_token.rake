namespace :api_token do
    desc 'Generate access token for Certified Cycle App'
    task certified_cycle_app: :environment do
        if ApiToken.where(name: 'Certified Cycle Appp').first.nil?
            ApiToken.generate_auth_token("Certified Cycle Appp")
        end
    end
end

