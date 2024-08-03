class AuthorBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :surname, :language, :deleted


  # association :courses, blueprint: CourseBlueprint
end
