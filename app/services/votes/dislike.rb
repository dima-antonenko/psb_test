module Votes
  class Dislike < Votes::Base
    attr_accessor :user, :params, :item, :item_type, :item_id

    def initialize(user, item_type, item_id)
      @user = user
      @item_type, @item_id = item_type, item_id
      @item = item_type.classify.safe_constantize.find_by(id: item_id)
    end

    def call
      validate!
      update_item(item) do
        item.liked_user_ids.include?(user.id) ? item.user.decrement!(:rating, 2) : item.user.decrement!(:rating)

        item.disliked_user_ids << user.id
        item.liked_user_ids.delete(user.id)
      end
    end

    private

    def validate!
      user_active?(user)
      item_type_valid?(item_type)
      item_valid?(item)
      item_already_disliked?(item, user.id)
    end
  end
end
