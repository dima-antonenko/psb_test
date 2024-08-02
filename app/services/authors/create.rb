module Authors
  class Create < BaseService
    include UserValidations
    include AuthorValidations
    attr_accessor :user, :params, :author, :request


    def initialize(user, params, request)
      @user = user
      @params = params
      @author = User.new
      @request = request
    end

    def call
      validate!
      assign!
      save_author(author, request)
    end

    private

    def validate!
      user_active?(user)
      author_spam?(user, request.remote_ip)
    end

    def assign!
      valid_prm = params.permit(:name, :surname, :email)
      pass = Devise.friendly_token.first(Devise.password_length.first)
      author.assign_attributes(valid_prm.merge!({ password: pass,
                                                  last_sign_in_ip: request.remote_ip }))
    end

    def save_author(author, request)
      return author.errors unless author.valid?
      ActiveRecord::Base.transaction do
        author.save!
        author.network_logs.create(user_id: user.id,
                                   event_type: 'create_author',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: author.id)
      end
      author.reload
      send_confirmed_email!(author)
      author
    end

    def send_confirmed_email!(author)
      # UserMailer.welcome_email(author).deliver_later
    end
  end
end
