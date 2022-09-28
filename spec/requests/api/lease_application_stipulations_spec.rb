require 'swagger_helper'

RSpec.describe 'api/lease-application-stipulations', type: :request do

  # path '/lease-application-stipulations' do
  #   post 'create a Lease Stipulation' do
  #     tags 'Stipulation'
  #     consumes 'application/json'
  #     response '201', 'Stipulation created' do
  #       parameter name: :application_identifier, :in => :path, :type => :string
  #         parameter name: :stipulation, in: :query, schema: {
  #           type: :object,
  #           properties: {
  #             stipulation_id: { type: :integer },
  #             status: { type: :string },
  #             notes: { type: :string }
  #           },
  #           required: [ 'stipulation_id', 'status', 'notes' ]
  #         }
        
  #         let(:application_identifier) { "2002040001" }
  #         let(:stipulation) { { stipulation_id: 23, status: 'Not Required', notes: 'Test Notes' } }
  #         run_test!
  #     end
  #   end
  # end

end
