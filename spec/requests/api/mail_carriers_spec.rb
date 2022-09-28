require 'swagger_helper'
=begin
RSpec.describe 'api/mail-carriers', type: :request do

  path '/mail-carriers' do
    get 'fetch Mail Carriers' do 
      tags 'Mail Carrier'
      consumes 'application/json'
      response '200', 'get Mail Carriers' do
        run_test!
      end
    end
  end

  path '/mail-carriers/update-active-mail-carriers' do
    put 'update Active' do 
      tags 'Mail Carrier'
      response '200', 'Active updated' do
        parameter name: :mail_carrier, in: :query, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          active: { type: :boolean }
        },
        required: [ 'id', 'active' ]
        }
        run_test!
      end
    end
  end


  path '/mail-carriers/update-description' do
    put 'update Description' do 
      tags 'Mail Carrier'
      response '200', 'Description updated' do
        parameter name: :mail_carrier, in: :query, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          description: { type: :string }
        },
        required: [ 'id', 'description' ]
        }
        run_test!
      end
    end
  end


  # path '/mail-carriers' do
  #   post 'create' do 
  #     tags 'Mail Carrier'
  #     response '200', 'Mail Carrier created' do
  #       parameter name: {}, in: :query, required: true, schema: {
  #       type: :object,
  #       properties: {
  #         mail_carrier: {
  #           type: :object,
  #           properties: {
  #             required: [ 'description' ],
  #             description: { type: :string }
  #           }
  #         }
  #       }
  #       }
  #       run_test!
  #     end
  #   end
  # end

end
=end