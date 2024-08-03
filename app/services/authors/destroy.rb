module Authors
  class Destroy < BaseService
    include UserValidations
    include AuthorValidations

    attr_accessor :user, :author, :request

    def initialize(user, author, request)
      @user = user
      @author = author
      @request = request
    end

    def call
      validate!
      author.assign_attributes({ deleted: true })
      save_author(author, request)
    end

    private

    def validate!
      user_active?(user)
      author_not_deleted?(author)
      user_has_access_to_author?(user, author)
      delete_himself?(user, author)
    end

    def save_author(author, request)
      return author.errors unless author.valid?
      ActiveRecord::Base.transaction do
        author.save
        author.network_logs.create(user_id: author.id,
                                   event_type: 'destroy_author',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: author.id)
      end
      author.reload

      author
    end
  end
end
