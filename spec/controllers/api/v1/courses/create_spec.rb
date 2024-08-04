require 'rails_helper'
RSpec.describe Api::V1::CoursesController, type: :request do
  let!(:user) { create(:user) }


  describe 'POST /api/v1/courses' do
    context 'Simple scenarios' do
      let!(:author) { create(:user) }
      let!(:expertise) { create(:expertise) }

      describe 'has access' do
        it 'not anon user can create course ' do
          json = create_course(user, {user_id: author.id, expertise_ids: [expertise.id]})

          course = Course.find(json['id'])

          expect(json['id']).to be_truthy
          expect(course.network_logs.size).to eq(1)

          log = course.network_logs.first
          expect(log.user_id).to eq(user.id)
          expect(log.event_type).to eq('create_course')
          expect(log.logable_id).to eq(course.id)
          expect(log.ip).not_to be_nil
        end
      end

      describe 'dont has access' do
        it 'unregistred user cant create course' do
        end

        it 'user cant create many courses' do
        end
      end
    end
  end
end
