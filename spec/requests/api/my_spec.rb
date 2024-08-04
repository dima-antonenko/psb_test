# spec/requests/blogs_spec.rb
require 'swagger_helper'

describe 'Blogs API' do

  path '/authors' do
    post 'Creates an author' do
      tags 'Authors'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          surname: { type: :string },
          email: { type: :string },
          locale: { type: :string, default: 'ru || en' }
        },
        required: [ 'name', 'surname' 'email' ]
      }

      response '201', 'Author created' do
        let(:author) { { name: 'foo', surname: 'bar' } }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:author) { { name: 'foo', surname: 'bar' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:author) { { name: 'foo', surname: 'bar' } }
        run_test!
      end
    end
  end

  path '/authors/{id}' do

    delete 'Delete an author' do
      tags 'Authors'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'Author delete' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Author not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:author) { { name: 'foo', surname: 'bar' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:author) { { name: 'foo', surname: 'bar' } }
        run_test!
      end
    end
  end
end
