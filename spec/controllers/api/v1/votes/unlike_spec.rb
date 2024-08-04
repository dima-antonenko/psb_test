require 'rails_helper'
RSpec.describe Api::V1::VotesController, type: :request do
  let!(:user) { create(:user) }
  let!(:expertise) { create(:expertise) }
  let!(:course) { create(:course, expertise_ids: [expertise.id]) }

  describe 'POST /api/v1/votes/unlike' do
    context 'Author' do
      describe 'has access' do
        it 'like + unlike' do
          json = set_like(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)

          json = unlike(user, { item_id: user.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['likes_qty']).to eq(0)
        end

        it 'dislike + unlike' do
          json = set_dislike(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(user.reload.rating).to eq(9)

          json = unlike(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['dislikes_qty']).to eq(0)
          expect(user.reload.rating).to eq(10)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant unlike' do
          json = set_dislike(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(user.reload.rating).to eq(9)

          User.destroy_all
          json = unlike(nil, { item_type: 'User', item_id: user.id })
          expect(json['errors']['user_id'].first).to eq('User not autorized')
        end

        it 'user cant liked invalid item_type' do
          # json = set_like(user, { item_type: 'User', item_type: '' })
          # expect(json['errors']['item_type'].first).to eq('Invalid item type')
        end

        it 'user cant unlike for invalid item_id' do
          json = set_dislike(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(user.reload.rating).to eq(9)

          json = unlike(user, { item_type: 'User', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(9)
        end

        it 'user cant set like to deleted user' do
          json = set_dislike(user, { item_type: 'User', item_id: user.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(user.reload.rating).to eq(9)

          review.update_attribute(:deleted, true)
          json = unlike(user, { item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(user.reload.rating).to eq(9)
        end

        it "user cant twice unlike record" do
        end
      end
    end

    context 'Course' do
      describe 'has access' do
        it 'like + unlike' do
          json = set_like(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)
          expect(course.user.reload.rating).to eq(11)

          json = unlike(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['likes_qty']).to eq(0)
          expect(course.user.reload.rating).to eq(10)
        end

        it 'dislike + unlike' do
          json = set_dislike(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(course.user.reload.rating).to eq(9)

          json = unlike(user, { item_type: 'Course', item_id: course.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['dislikes_qty']).to eq(0)
          expect(course.user.reload.rating).to eq(10)
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
          expect(json['errors']['liked_user_ids'].first).to eq('Item already liked')
          expect(course.user.reload.rating).to eq(11)
        end
      end
    end

    context 'Expertise' do
      describe 'has access' do
        it 'like + unlike' do
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('liked')
          expect(json['likes_qty']).to eq(1)
          expect(expertise.reload.rating).to eq(11)

          json = unlike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['likes_qty']).to eq(0)
          expect(expertise.reload.rating).to eq(10)
        end

        it 'dislike + unlike' do
          json = set_dislike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('disliked')
          expect(json['dislikes_qty']).to eq(1)
          expect(expertise.reload.rating).to eq(9)

          json = unlike(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('not_voted')
          expect(json['dislikes_qty']).to eq(0)
          expect(expertise.reload.rating).to eq(10)
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create set like' do
          json = set_like(nil, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['user_id'].first).to eq('User not authorized')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant liked for invalid item_id' do
          json = set_like(user, { item_type: 'Expertise', item_id: '' })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant set like to deleted expertise' do
          expertise.update_attribute(:deleted, true)
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['item_id'].first).to eq('Related record not valid')
          expect(expertise.reload.rating).to eq(10)
        end

        it 'user cant twice like one record' do
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['vote_state']).to eq('liked')
          expect(expertise.reload.rating).to eq(11)
          json = set_like(user, { item_type: 'Expertise', item_id: expertise.id })
          expect(json['errors']['liked_user_ids'].first).to eq('Item already liked')
          expect(expertise.reload.rating).to eq(11)
        end
      end
    end

  end
end
