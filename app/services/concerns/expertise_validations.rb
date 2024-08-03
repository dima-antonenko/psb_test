module ExpertiseValidations
  def expertise_not_deleted?(expertise)
    raise PermissionError.new(:expertise_id, 'Expertise deleted') if expertise&.deleted
  end
end
