class Api::V1::ExpertisesController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :get_expertise, only: [:update, :destroy]

  def create
    result = Expertises::Create.new(current_user, expertise_params, request).call
    render_item(result, serializer: 'ExpertiseBlueprint')
  end

  def update
    result = Expertises::Update.new(current_user, @expertise, expertise_params, request).call
    render_item(result, serializer: 'ExpertiseBlueprint')
  end

  def destroy
    result = Expertises::Destroy.new(current_user, @expertise, request).call
    render_item(result, serializer: 'ExpertiseBlueprint')
  end

  private

  def get_expertise
    @expertise = User.find_by(id: params[:id])
  end

  def expertise_params
    params.require(:expertise).permit(:title)
  end
end
