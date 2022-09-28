require 'swagger_helper'
=begin
RSpec.describe 'api/email_templates', type: :request do
  path '/email_templates/get_details' do
    get 'fetch email template' do 
      tags 'Email Templates'
      consumes 'application/json'
      parameter name: :id, in: :query, schema: {
        type: :object,
        properties: {
          id: { type: :integer }
        },
        required: ['id']
      }
      response '200', 'get details' do
        let(:id) { 1 }
        run_test!
      end
    end
  end

  path '/email_templates/{id}' do
    put 'update email template' do 
      tags 'Update Email Templates'
        parameter name: :id, :in => :path, :type => :string

        response '200', 'name found' do
          schema type: :object,
            properties: {
              id: { type: :integer, }
            },
            required: [ 'id' ]

          let(:id) { 1 }
          
          parameter name: :template, in: :query, schema: {
            type: :object,
            properties: {
              enable_template: { type: :boolean },
              template: { type: :string }
            }
          }
          run_test!
        end
    end
  end
end
=end