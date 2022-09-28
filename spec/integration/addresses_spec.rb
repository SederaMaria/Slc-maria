# spec/integration/comments_spec.rb
require 'swagger_helper'
=begin
RSpec.describe 'Addresses API', type: :request do  
  path '/address' do
    get 'fetch all addresses' do 
      tags 'Address'
      consumes 'application/json'
        parameter name: :address, in: :query, schema: {
          type: :object,
          properties: {
            state: { 
              type: :object,
              properties: {
                name: { type: :string }
              }
            },
            county: { 
              type: :object,
              properties: {
                name: { type: :string }
              }
            }
          },
          required: [ 'state', 'county' ]
        }
      response '200', 'Fetch all addresses ' do
        let(:address) { {state: { name: 'ca-california' }, county: { name: 'US' }} }
        run_test!
      end
    end
  end
  path '/address/find_city' do
    get 'Find a city' do
      tags 'Find City'
      consumes 'application/json'
      parameter name: :zipcode, in: :query, schema: {
        type: :object,
        properties: {
          zipcode: { type: :integer }
        },
        required: ['zipcode']
      }
      response '200', 'find a city' do
        let(:zipcode) { 29229 }
        run_test!
      end
    end
  end
end
=end