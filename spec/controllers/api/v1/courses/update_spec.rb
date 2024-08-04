require 'rails_helper'
RSpec.describe Api::V1::CoursesController, type: :request do
  let!(:user) { create(:user, full_access: true) }


  # update
  describe 'PATCH /api/v1/courses/:id' do
    context 'positive scenarios' do
      let!(:author) { create(:user) }
      let!(:expertise) { create(:expertise) }
      let!(:second_expertise) { create(:expertise) }


      it 'user can update course' do
        json = create_course(user, {user_id: author.id, expertise_ids: [expertise.id]})
        expect(json['expertises'].size).to eq(1)

        json = update_course(user , json['id'], { title: 'updated title', expertise_ids: [expertise.id, second_expertise.id] })
        expect(json['expertises'].size).to eq(2)
        expect(json['title']).to eq('updated title')
      end
    end

    context 'negative scenarious' do
    end
  end
end
