require 'rails_helper'
RSpec.describe Api::V1::AuthorsController, type: :request do
  let!(:user) { create(:user) }


  describe 'POST /api/v1/authors' do
    context 'for review' do
      describe 'has access' do
        it 'not anon user can create author ' do
          json = create_author(user)

          author = User.find(json['id'])

          expect(json['id']).to be_truthy
          expect(author.network_logs.size).to eq(1)

          log = author.network_logs.first
          expect(log.user_id).to eq(author.id)
          expect(log.event_type).to eq('create_author')
          expect(log.logable_id).to eq(author.id)
          expect(log.ip).not_to be_nil
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create author' do
          json = create_author(nil, )
          expect(json['errors']['user_id'].first).to eq('User not authorized')
        end

        it 'user cant create many author' do
          10.times do |t|
            json = create_author(user)
            expect(response.status).to eq(200)
          end
          json = create_author(user)
          expect(json['errors']['created_at'].first).to eq('Time limit exeeded')
        end
      end
    end
  end
end
