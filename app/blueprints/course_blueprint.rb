class CourseBlueprint < Blueprinter::Base
  identifier :id
  association :expertises, blueprint: ExpertiseBlueprint

  fields :title, :description, :deleted

  field :author do |course|
    if course.user
      u = course.user
      {
        id: u.id,
        name: u.name,
        surname: u.surname,
        rating: u.rating
      }
    end
  end

  # field :attachments do |course|
  #   if course.attachments.attached?
  #     course.attachments
  #           .where(deleted: false).map { |a| { id: a.id,
  #                                              path: Rails.application.routes.url_helpers
  #                                                         .rails_blob_path(a, only_path: true) } }
  #   else
  #     []
  #   end
  # end

  field :vote_state do |course, params|
    user = params[:current_user]
    if user
      if course.liked_user_ids.include?(user.id)
        'liked'
      elsif course.disliked_user_ids.include?(user.id)
        'disliked'
      else
        'not_voted'
      end
    else
      'not_voted'
    end
  end

  field :likes_qty do |course|
    course.liked_user_ids.size
  end

  field :dislikes_qty do |course|
    course.disliked_user_ids.size
  end
end
