require 'rails_helper'
RSpec.describe Api::V1::AuthorsController, type: :request do
  let!(:user) { create(:user, full_access: true) }


  # update
  describe 'PATCH /api/v1/authors/:id' do
    context 'positive scenarios' do
      it 'user can update author' do
        json = create_author(user)
        json = update_author(user, json['id'] )
        author = User.find(json['id'])

        expect(json['name']).to eq('new_name')
        expect(json['surname']).to eq('new_surname')

        #expect(author.versions.last.changeset.to_a[0]).to eq(["name", ["old name", "new_name"]])
        #expect(author.versions.last.changeset.to_a[1]).to eq( ["surname", ["old surname", "new_surname"]])


        log = author.network_logs.last
        expect(log.user_id).to eq(author.id)
        expect(log.event_type).to eq('update_author')
        expect(log.logable_id).to eq(author.id)
        expect(log.ip).not_to be_nil
      end
    end

    context 'negative scenarious' do
      it 'user cannot update deleted author' do
        json = create_author(user)
        User.find(json['id']).update_attribute(:deleted, :true)
        json = update_author(user, json['id'] )
        expect(json['errors']['deleted'].first).to eq('Author deleted')
      end

      it 'user cannot update deleted author' do
        json = create_author(user)
        User.find(json['id']).update_attribute(:deleted, :true)

        json = update_author( create(:user), json['id'] )
        expect(json['errors']['deleted'].first).to eq('Author deleted')
      end


      it 'deleted user cannot update author' do
        json = create_author(user)
        user.update_attribute(:deleted, true)

        json = update_author(user, json['id'] )
        expect(json['errors']['user_id'].first).to eq('User not authorized')
      end
    end
  end
end
