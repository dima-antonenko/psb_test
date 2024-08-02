class Api::V1::AuthorsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :get_author, only: [:update, :destroy]

  def create
    result = Authors::Create.new(current_user, author_params, request).call
    render_item(result, serializer: 'AuthorBlueprint')
  end

  def update
    result = Authors::Update.new(current_user, @author, author_params, request).call
    render_item(result, serializer: 'AuthorBlueprint')
  end

  def destroy
    result = Authors::Destroy.new(current_user, @author, request).call
    render_item(result, serializer: 'AuthorBlueprint')
  end

  private

  def get_author
    @author = User.find_by(id: params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :surname, :email, :locale)
  end
end
