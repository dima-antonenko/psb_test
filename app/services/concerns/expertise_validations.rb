module ExpertiseValidations
  def expertise_not_deleted?(expertise)
    raise PermissionError.new(:deleted, 'Expertise deleted') if expertise&.deleted
  end

  def user_has_access_to_expertise?(user, expertise)
    raise PermissionError.new(:user_id, 'User cant access') unless user.full_access
  end
end
