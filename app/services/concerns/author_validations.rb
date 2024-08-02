module AuthorValidations
  MAX_UPDATE_TIME = 24.hours

  def author_spam?(user, ip)
    size = User.where(last_sign_in_ip: ip, created_at: (1.hour.ago..DateTime.now)).size
    if size >= 10 && !user.full_access
      raise ForbiddenError.new(:created_at, 'Time limit exeeded')
    end
  end

  def user_has_access_to_author?(user, author)
    raise PermissionError.new(:user_id, 'User cant access') unless user.full_access
  end

  def author_not_deleted?(author)
    raise PermissionError.new(:deleted, 'Author deleted') if !author || author.deleted
  end
end
