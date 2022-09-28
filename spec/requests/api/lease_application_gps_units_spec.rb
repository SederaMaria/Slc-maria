require 'swagger_helper'

# TO DO: Fix authorization so this and all /requests tests can run
=begin
RSpec.describe 'api/lease_application_gps_units', type: :request do

  let(:access_token) { FactoryBot.create(:api_token) }
  let(:Authorization) { "Token #{access_token}" }
  
  path "/lease-application-gps-units?id={id}" do
    get 'Returns GPS unit by ID' do
      tags 'GPS'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :integer

      response '200', 'Success' do
        examples 'application/json' => {
          {
            id: 3,
            lease_application_id: 39932,
            gps_serial_number: 'a1234b56',
            active: false,
            created_by_admin_id: 132,
            updated_by_admin_id: 3,
            created_at: '2021-06-30T19:41:31.539-04:00',
            updated_at: '2021-07-01T15:59:30.307-04:00'
          }
        }
        schema type: :object,
          properties: {
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                lease_application_id: { type: :integer },
                gps_serial_number: { type: :string },
                active: { type: :boolean },
                created_by_admin_id: { type: :integer },
                updated_by_admin_id: { type: :integer },
                created_at: { type: :datetime },
                updated_at: { type: :datetime }
              }
            }
          }
       
        run_test!
      end
    end
  end

  path '/lease-application-gps-units' do
    put 'Update GPS unit' do 
      tags 'GPS'
        parameter name: :id, :in => :path, :type => :string

        response '200', 'GPS unit has been successfully updated.' do
          schema type: :object,
            properties: {
              lease_application_id: { type: :integer },
              gps_serial_number: { type: :string },
              active: { type: :boolean },
              created_by_admin_id: { type: :integer },
              updated_by_admin_id: { type: :integer }
            },
            required: [ 'id' ]

          let(:id) { 1 }
          
          parameter name: :id, in: :query, schema: {
            type: :object,
            properties: {
              lease_application_id: { type: :integer },
              gps_serial_number: { type: :string },
              active: { type: :boolean },
              created_by_admin_id: { type: :integer },
              updated_by_admin_id: { type: :integer }
            }
          }
          run_test!
        end
    end
  end

  path '/lease-application-gps-units' do
    post 'Create a Lease GPS unit' do
      tags 'GPS'
      consumes 'application/json'
      response '201', 'Successfully created' do        
        parameter name: :gps_unit, in: :query, schema: {
          type: :object,
          properties: {
            lease_application_id: { type: :integer },
            gps_serial_number: { type: :string },
            active: { type: :boolean },
            created_by_admin_id: { type: :integer },
            updated_by_admin_id: { type: :integer }
          },
          required: [ 'lease_application_id', 'gps_serial_number', 'active' ]
        }
      
        let(:gps_unit) { { lease_application_id: 39932, gps_serial_number: '500052abc', active: true, created_by_admin_id: 3 } }
        run_test!
      end
    end
  end  

  path '/lease-application-gps-units' do
    delete 'Delete GPS unit' do 
      tags 'GPS'
        parameter name: :id, :in => :path, :type => :string

        response '200', 'GPS unit has been successfully deleted.' do
          schema type: :object,
            required: [ 'id' ]

          let(:id) { 1 }

          run_test!
        end
    end
  end

end
=end