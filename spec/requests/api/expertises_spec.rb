# spec/requests/blogs_spec.rb
require 'swagger_helper'

describe 'Authors API' do

  path '/expertises' do
    post 'Creates an expertise' do
      tags 'Expertises'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: [ 'title' ]
      }

      response '201', 'Expertise created' do
        let(:expertise) { { title: 'foo' } }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:expertise) { { title: 'foo' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:expertise) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/expertises/{id}' do

    delete 'Delete an expertise' do
      tags 'Expertises'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'Expertis delete' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Expertis not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:expertise) { { title: 'foo' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:expertise) { { title: 'foo' } }
        run_test!
      end
    end
  end


  path '/api/v1/expertises' do
    patch 'Update expertise' do
      tags 'Expertises'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: [ 'title' ]
      }

      response '200', 'Expertis update' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '404', 'Expertis not found' do
        run_test!
      end

      response '500', 'Forbidden request' do
        run_test!
      end
    end
  end
end
