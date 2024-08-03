require 'rails_helper'
RSpec.describe Api::V1::ExpertisesController, type: :request do
  let!(:user) { create(:user) }

  describe 'POST /api/v1/expertises' do
    context 'for review' do
      describe 'has access' do
        it 'not anon user can create expertise ' do
          json = create_expertise(user)

          expertise = Expertise.find(json['id'])

          expect(json['id']).to be_truthy
          expect(expertise.network_logs.size).to eq(1)

          log = expertise.network_logs.first
          expect(log.user_id).to eq(user.id)
          expect(log.event_type).to eq('create_expertise')
          expect(log.logable_id).to eq(expertise.id)
          expect(log.ip).not_to be_nil
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create expertise' do
          json = create_expertise(nil, )
          expect(json['errors']['user_id'].first).to eq('User not authorized')
        end
      end
    end
  end
end
