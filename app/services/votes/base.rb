module Votes
  class Base < BaseService
    include UserValidations
    include VoteValidations

    def update_item(item, &block)
      if item.valid?
        item.with_lock do
          block&.call if block_given?
          item.save
        end
        item.reload
        item
      else
        item.errors
      end
    end
  end
end
