require 'rails_helper'
RSpec.describe Api::V1::VotesController, type: :request do
  let!(:user) { create(:user) }
  let!(:expertise) { create(:expertise) }
  let!(:course) { create(:course, user_id: user.id, expertise_ids: [expertise.id]) }


  describe 'POST /api/v1/votes/like' do
    context 'Course' do
      describe 'has access' do
        it 'user can set like' do
          json = set_like(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)
          expect(course.user.reload.rating).to eq(11)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set like' do
          json = set_like(nil, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['user_id'].first).to eq('User not authorized')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant liked for invalid item_id' do
          json = set_like(user, { item_type: 'Course', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant set like to deleted course' do
          course.update_attribute(:deleted, true)
          json = set_like(user, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant twice like one record' do
          json = set_like(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('liked')
          expect(course.user.reload.rating).to eq(11)
          json = set_like(user, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['liked_user_ids'].first).to eq('Already liked')
          expect(course.user.reload.rating).to eq(11)
        end
      end
    end

  end
end
