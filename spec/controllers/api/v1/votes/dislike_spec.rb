require 'rails_helper'
RSpec.describe Api::V1::VotesController, type: :request do
  let!(:user) { create(:user) }
  let!(:expertise) { create(:expertise) }
  let!(:course) { create(:course, expertise_ids: [expertise.id]) }

  describe 'POST /api/v1/votes/dislike' do
    context 'User' do
      describe 'has access' do
        it 'user can set dislike' do
          json = set_dislike(user)
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(user.reload.rating).to eq(9)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set dislike' do
          json = set_dislike(nil)
          expect(json['errors']['user_id'].first).to eq('Not authorized')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant disliked invalid item_type' do
          # json = set_dislike(user, { item_type: '' })
          # expect(json['errors']['item_type'].first).to eq('Invalid item type')
        end

        it 'user cant disliked for invalid item_id' do
          json = set_dislike(user, { item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant set dislike to deleted user' do
          user.update_attribute(:deleted, true)
          json = set_dislike(user)
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(10)
        end

        it 'user cant twice dislike one record' do
          json = set_dislike(user)
          expect(json['vote_state']).to eq('disliked')
          expect(user.reload.rating).to eq(9)

          json = set_dislike(user)
          expect(user.reload.rating).to eq(9)
          expect(json['errors']['disliked_user_ids'].first).to eq('Already liked')
        end
      end
    end

    context 'Course' do
      describe 'has access' do
        it 'user can set dislike' do
          json = set_dislike(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(course.user.reload.rating).to eq(9)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set dislike' do
          json = set_dislike(nil, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['user_id'].first).to eq('Not authorized')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant disliked for invalid item_id' do
          json = set_dislike(user, { item_type: 'Course', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant set dislike to deleted course' do
          course.update_attribute(:deleted, true)
          json = set_dislike(user, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(course.user.reload.rating).to eq(10)
        end

        it 'user cant twice dislike one record' do
          json = set_dislike(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('disliked')
          expect(course.user.reload.rating).to eq(9)
          json = set_dislike(user, { item_type: 'Course', item_id: course.id })
          expect(json['errors']['disliked_user_ids'].first).to eq('Already liked')
          expect(course.user.reload.rating).to eq(9)
        end
      end
    end

    context 'Expertise' do
      describe 'has access' do
        it 'user can set dislike' do
          json = set_dislike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(expertise.reload.rating).to eq(9)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set dislike' do
          json = set_dislike(nil, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['user_id'].first).to eq('Not authorized')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant disliked for invalid item_id' do
          json = set_dislike(user, { item_type: 'Expertise', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant set dislike to deleted Expertise' do
          expertise.update_attribute(:deleted, true)
          json = set_dislike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant twice dislike one record' do
          json = set_dislike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('disliked')
          expect(expertise.reload.rating).to eq(9)
          json = set_dislike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['disliked_user_ids'].first).to eq('Already liked')
          expect(expertise.reload.rating).to eq(9)
        end
      end
    end

  end
end
