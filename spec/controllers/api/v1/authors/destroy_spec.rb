require 'rails_helper'
RSpec.describe Api::V1::AuthorsController, type: :request do
  let!(:user) { create(:user, full_access: true) }

  # destroy
  describe 'DELETE /api/v1/authors/:id' do
    context 'positive scenarios' do
      it 'author creator can destroy his author' do
        json = create_author(user)
        json = destroy_author(user, json['id'] )

        author = User.find(json['id'])

        expect(json['deleted']).to eq(true)

        # expect(author.versions.last.changeset.to_a[0]).to eq(["deleted", [false , true]])

        log = author.network_logs.last
        expect(log.user_id).to eq(author.id)
        expect(log.event_type).to eq('destroy_author')
        expect(log.logable_id).to eq(author.id)
        expect(log.ip).not_to be_nil
      end
    end

    context 'negative scenarious' do
      it 'user cannot delete already deleted author' do
        json = create_author(user)
        User.find(json['id']).update_attribute(:deleted, true)
        json = destroy_author(user, json['id'] )
        expect(json['errors']['deleted'].first).to eq('Author deleted')
      end


      it 'deleted user cannot destroy author' do
        json = create_author(user)
        user.update_attribute(:deleted, true)
        json = destroy_author(user, json['id'] )
        expect(json['errors']['user_id'].first).to eq('User not authorized')
      end
    end
  end
end
