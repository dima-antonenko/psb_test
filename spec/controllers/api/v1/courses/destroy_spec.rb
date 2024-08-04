require 'rails_helper'
RSpec.describe Api::V1::CoursesController, type: :request do
  let!(:user) { create(:user, full_access: true) }


  # update
  describe 'DELETE /api/v1/courses/:id' do
    context 'positive scenarios' do
      let!(:author) { create(:user) }
      let!(:expertise) { create(:expertise) }
      let!(:second_expertise) { create(:expertise) }


      it 'user can delete course' do
        json = create_course(user, {user_id: author.id, expertise_ids: [expertise.id]})
        expect(json['expertises'].size).to eq(1)

        json = destroy_course(user , json['id'])
        expect(json['deleted']).to be_truthy
      end
    end

    context 'negative scenarious' do
    end
  end
end
