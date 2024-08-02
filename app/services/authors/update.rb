module Authors
  class Update < BaseService
    include UserValidations
    include AuthorValidations

    attr_accessor :user, :params, :author, :request

    def initialize(user, author, params, request)
      @user = user
      @author = author
      @params = params
      @request = request
    end

    def call
      validate!
      author.assign_attributes(params)
      save_author(author, request)
    end

    private

    def validate!
      user_active?(user)
      author_not_deleted?(author)
      user_has_access_to_author?(user, author)
    end

    def save_author(author, request)
      return author.errors unless author.valid?
      ActiveRecord::Base.transaction do
        author.save
        author.network_logs.create(user_id: user.id,
                                   event_type: 'update_author',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: author.id)
      end
      author.reload

      author
    end
  end
end
