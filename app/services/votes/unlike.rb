module Votes
  class Unlike < Votes::Base
    include UserValidations
    include VoteValidations

    attr_accessor :user, :params, :item, :item_type, :item_id

    def initialize(user, item_type, item_id)
      @user = user
      @item_type, @item_id = item_type, item_id
      @item = item_type.classify.safe_constantize.find_by(id: item_id)
    end

    def call
      validate!
      update_item(item) do
        item.user.increment!(:rating) if item.disliked_user_ids.include?(user.id)
        item.user.decrement!(:rating) if item.liked_user_ids.include?(user.id)

        item.liked_user_ids.delete(user.id)
        item.disliked_user_ids.delete(user.id)
      end
    end

    private

    def validate!
      user_active?(user)
      item_type_valid?(item_type)
      item_valid?(item)
      item_already_voted?(item, user.id)
    end
  end
end
