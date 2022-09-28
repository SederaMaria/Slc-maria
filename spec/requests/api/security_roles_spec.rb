require 'swagger_helper'
=begin
RSpec.describe 'api/security-roles', type: :request do


  path '/security-roles/can-see-welcome-call-dashboard' do
    get 'fetch Security Roles to see welcome call dashbaord' do 
      tags 'Security Roles'
      consumes 'application/json'
      response '200', 'get Security Roles' do
        run_test!
      end
    end
  end

end
=end
