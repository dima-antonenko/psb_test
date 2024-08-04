class Api::V1::VotesController < ApplicationController
  before_action :authenticate_user_from_token!
  def like
    result = Votes::Like.new(current_user, params[:vote][:item_type], params[:vote][:item_id]).call
    render_item(result)
  end

  def unlike
    result = Votes::Unlike.new(current_user, params[:vote][:item_type], params[:vote][:item_id]).call
    render_item(result)
  end

  def dislike
    result = Votes::Dislike.new(current_user, params[:vote][:item_type], params[:vote][:item_id]).call
    render_item(result)
  end
end
