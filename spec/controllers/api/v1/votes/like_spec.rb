require 'rails_helper'
RSpec.describe Api::V1::VotesController, type: :request do
  let!(:user) { create(:user) }
  let!(:expertise) { create(:expertise) }
  let!(:course) { create(:course, expertise_ids: [expertise.id]) }


  describe 'POST /api/v1/votes/like' do
    context 'User' do
      describe 'has access' do
        it 'user can set like' do
          json = set_like(user)
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)
          expect(user.reload.rating).to eq(11)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set like' do
          json = set_like(nil)
          expect(json['errors']['user_id'].first).to eq('User not autorized')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant liked invalid item_type' do
          # json = set_like(user, { item_type: '' })
          # expect(json['errors']['item_type'].first).to eq('Invalid item type')
        end

        it 'user cant liked for invalid item_id' do
          json = set_like(user, { item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant set like to deleted user' do
          user.update_attribute(:deleted, true)
          json = set_like(user)
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant twice like one record' do
          json = set_like(user)
          expect(json['vote_state']).to eq('liked')
          expect(user.reload.rating).to eq(11)

          json = set_like(user)
          expect(user.reload.rating).to eq(11)
          expect(json['errors']['liked_user_ids'].first).to eq('Already liked')
        end
      end
    end

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
          expect(json['errors']['user_id'].first).to eq('User not autorized')
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

    context 'Expertise' do
      describe 'has access' do
        it 'user can set like' do
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)
          expect(expertise.user.reload.rating).to eq(11)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set like' do
          json = set_like(nil, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['user_id'].first).to eq('User not autorized')
          expect(expertise.user.reload.rating).to eq(10)
        end

        it 'user cant liked for invalid item_id' do
          json = set_like(user, { item_type: 'Course', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.user.reload.rating).to eq(10)
        end

        it 'user cant set like to deleted expertise' do
          expertise.update_attribute(:deleted, true)
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.user.reload.rating).to eq(10)
        end

        it 'user cant twice like one record' do
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('liked')
          expect(expertise.user.reload.rating).to eq(11)
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['liked_user_ids'].first).to eq('Already liked')
          expect(expertise.user.reload.rating).to eq(11)
        end
      end
    end

  end
end
