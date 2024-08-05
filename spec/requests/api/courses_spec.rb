# spec/requests/blogs_spec.rb
require 'swagger_helper'

describe 'Authors API' do

  path '/courses' do
    post 'Creates an course' do
      tags 'Courses'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          description: { type: :string },
          expertise_ids: { type: :string, default: '[]' }
        },
        required: [ 'user_id', 'title' 'description', 'expertise_ids' ]
      }

      response '201', 'Course created' do
        let(:course) { { title: 'foo' } }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:course) { { title: 'foo' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:course) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/courses/{id}' do
    delete 'Delete an course' do
      tags 'Courses'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'Course delete' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Course not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '403', 'Invalid permission rule' do
        let(:course) { { title: 'foo' } }
        run_test!
      end

      response '500', 'Invalid permission rule' do
        let(:course) { { title: 'foo' } }
        run_test!
      end
    end
  end


  path '/api/v1/courses' do
    patch 'Update course' do
      tags 'Courses'
      consumes 'application/json'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          description: { type: :string },
          expertise_ids: { type: :string, default: '[]' }
        },
        required: [ 'user_id', 'title' 'description', 'expertise_ids' ]
      }

      response '200', 'Course update' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '404', 'Course not found' do
        run_test!
      end

      response '500', 'Forbidden request' do
        run_test!
      end
    end
  end


  path '/api/v1/courses/simple_search' do
    get 'Search product' do
      tags 'Courses'
      produces 'application/json'
      parameter name: :q, in: :path, type: :id
      response '200', 'Product found' do
        run_test!
      end
    end
  end
end
