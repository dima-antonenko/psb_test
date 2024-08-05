require 'rails_helper'
RSpec.describe Api::V1::CoursesController, type: :request do
  let!(:user) { create(:user) }


  describe 'GET /api/v1/courses/simple_search' do
    context 'Simple scenarios' do
      let!(:author) { create(:user) }
      let!(:frontend_expertise) { create(:expertise, title: 'Frontend') }
      let!(:backend_expertise) { create(:expertise, title: 'Backend') }

      describe 'has access' do
        it 'Test simple search' do
          good_course = create_course(user, {title: 'Good course', user_id: author.id, expertise_ids: [backend_expertise.id]})
          bad_course = create_course(user, {title: 'Bad course', user_id: author.id, expertise_ids: [frontend_expertise.id]})

          # Ищем хороший курс и курс по бекенду
          json = simple_search_course('Good')
          expect(json['items'].size).to eq(1)
          expect(json['items'].first['id']).to eq(good_course['id'])

          json = simple_search_course('Backend')
          expect(json['items'].size).to eq(1)
          expect(json['items'].first['id']).to eq(good_course['id'])


          # Ищем плохой курс и курс по фронтенду
          json = simple_search_course('Bad')
          expect(json['items'].size).to eq(1)
          expect(json['items'].first['id']).to eq(bad_course['id'])

          json = simple_search_course('Frontend')
          expect(json['items'].size).to eq(1)
          expect(json['items'].first['id']).to eq(bad_course['id'])
        end
      end
    end
  end
end
