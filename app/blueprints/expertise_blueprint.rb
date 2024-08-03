class ExpertiseBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :deleted

  # field :courses do |expertise|
  #   Course.where('expertise_ids @> ?', expertise.id).limit(1000).select(:id, :title)
  # end
end
