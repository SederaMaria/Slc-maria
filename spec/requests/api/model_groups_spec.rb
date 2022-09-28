require 'swagger_helper'
=begin
RSpec.describe 'Model Groups', type: :request do
  
  path '/model-groups?make_id={make_id}' do

    get 'Returns list of model groups by make ID' do
      tags 'Makes'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :make_id, in: :path, type: :integer

      response '200', 'Success' do
        examples 'application/json' => {
          message: 'Model Groups List Data',
          model_groups: [
            {
              id: 3,
              name: 'Sportster',
              sort_index: 1
            },
            {
              id: 5,
              name: 'dyna',
              sort_index: 2
            }
          ]
        }
        schema type: :object,
          properties: {  
            message: { type: :string },
            model_groups: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  make_id: { type: :integer },
                  name: { type: :string },
                  sort_index: { type: :integer }
                }
              }
            }
          },
          required: [ 'make_id' ]
       
        run_test!
      end

      response '404', 'Not found' do
        let(:make_id) { 'invalid' }
        run_test!
      end

    end

  end

  path '/model-groups/sort-order' do
    put 'Updates the sort order used by the UI' do
      tags 'Model Groups'
      produces 'application/json'
      consumes 'application/json'

      response '200', 'Sort order updated' do
        parameter name: :modelGroups, in: :body, required: true, schema: {
          type: :object,
          properties: {
            modelGroups: { 
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer }, 
                  sortIndex: { type: :integer }
                }
              } 
            }
          }
        }
        run_test!
      end
    end
  end
end
=end