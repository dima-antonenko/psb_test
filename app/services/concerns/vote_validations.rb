module VoteValidations
  def item_type_valid?(item_type)
    raise PermissionError.new(:item_type, 'Item not valid') unless ['User', 'Course', 'Competition'].include?(item_type)
  end

  def item_valid?(item)
    raise PermissionError.new(:item_id, 'Related record not valid') if !item || item.deleted
  end

  def item_already_liked?(item, user_id)
    raise PermissionError.new(:liked_user_ids, 'Already liked') if item.liked_user_ids.include? user_id
  end

  def item_already_disliked?(item, user_id)
    raise PermissionError.new(:disliked_user_ids, 'Already disliked') if item.disliked_user_ids.include? user_id
  end

  def item_already_voted?(item, user_id)
    if !item.liked_user_ids.include?(user_id) && !item.disliked_user_ids.include?(user_id)
      raise PermissionError.new(:item_id, 'Already voted')
    end
  end
end
