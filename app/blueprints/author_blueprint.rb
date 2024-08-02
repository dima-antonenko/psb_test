class AuthorBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :surname, :language


  # association :courses, blueprint: CourseBlueprint
end
