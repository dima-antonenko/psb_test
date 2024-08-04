module CourseValidations
  def course_not_deleted?(course)
    raise PermissionError.new(:deleted, 'Course deleted') if course&.deleted
  end

  def user_has_access_to_course?(user, course)
    raise PermissionError.new(:user_id, 'User cant access') unless user.full_access
  end
end
