class ExpertiseBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description

  field :course do |expertise|
    c = expertise.course
    if c
      {
        id: c.id,
        name: c.title,
        surname: c.description
      }
    end
  end
end
