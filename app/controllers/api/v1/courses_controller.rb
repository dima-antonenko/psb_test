class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :get_course, only: [:update, :destroy]

  def create
    result = Courses::Create.new(current_user, course_params, request).call
    render_item(result, serializer: 'CourseBlueprint')
  end

  def update
    result = Courses::Update.new(current_user, @course, course_params, request).call
    render_item(result, serializer: 'CourseBlueprint')
  end

  def destroy
    result = Courses::Destroy.new(current_user, @course, request).call
    render_item(result, serializer: 'CourseBlueprint')
  end

  private

  def get_course
    @course = Course.find_by(id: params[:id])
  end

  def course_params
    params.require(:course).permit(:user_id, :title, :description)
  end
end
