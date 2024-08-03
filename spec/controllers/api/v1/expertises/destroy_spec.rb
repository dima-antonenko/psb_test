require 'rails_helper'
RSpec.describe Api::V1::ExpertisesController, type: :request do
  let!(:user) { create(:user, full_access: true) }

  # destroy
  describe 'DELETE /api/v1/expertises/:id' do
    context 'positive scenarios' do
      it 'expertise creator can destroy his expertise' do
        json = create_expertise(user)
        json = destroy_expertise(user, json['id'] )
        expertise = Expertise.find(json['id'])

        expect(json['deleted']).to eq(true)

        # expect(expertise.versions.last.changeset.to_a[0]).to eq(["deleted", [false , true]])

        log = expertise.network_logs.last
        expect(log.user_id).to eq(expertise.id)
        expect(log.event_type).to eq('destroy_expertise')
        expect(log.logable_id).to eq(expertise.id)
        expect(log.ip).not_to be_nil
      end
    end

    context 'negative scenarious' do
      it 'user cannot delete already deleted expertise' do
        json = create_expertise(user)
        Expertise.find(json['id']).update_attribute(:deleted, true)
        json = destroy_expertise(user, json['id'] )
        expect(json['errors']['deleted'].first).to eq('Expertise deleted')
      end


      it 'deleted user cannot destroy expertise' do
        json = create_expertise(user)
        user.update_attribute(:deleted, true)
        json = destroy_expertise(user, json['id'] )
        expect(json['errors']['user_id'].first).to eq('User not authorized')
      end
    end
  end
end
