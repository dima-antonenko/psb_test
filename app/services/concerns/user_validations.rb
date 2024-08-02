module UserValidations
  def user_active?(user)
    raise PermissionError.new(:user_id, 'User not authorized') if !user || user.deleted
  end

  def user_not_deleted?(user)
    raise PermissionError.new(:user_id, 'User deleted') if user&.deleted
  end

  def unregistred_user_not_spammer?(user, ip)
    if !user && NetworkLog.where(event_type: 'create_author',
                                 ip: ip,
                                 created_at: (1.hour.ago)..DateTime.now).size > 20
      raise PermissionError.new(:user_id, 'User spammer')
    end
  end
end
