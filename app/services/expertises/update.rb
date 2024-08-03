module Expertises
  class Update < BaseService
    include UserValidations
    include ExpertiseValidations

    attr_accessor :user, :params, :expertise, :request

    def initialize(user, expertise, params, request)
      @user = user
      @expertise = expertise
      @params = params
      @request = request
    end

    def call
      validate!
      expertise.assign_attributes(params)
      save_expertise(expertise, request)
    end

    private

    def validate!
      user_active?(user)
      expertise_not_deleted?(expertise)
      user_has_access_to_expertise?(user, expertise)
    end

    def save_expertise(expertise, request)
      return expertise.errors unless expertise.valid?
      ActiveRecord::Base.transaction do
        expertise.save
        expertise.network_logs.create(user_id: user.id,
                                   event_type: 'update_expertise',
                                   ip: request.remote_ip,
                                   user_agent: request.user_agent,
                                   logable_id: expertise.id)
      end
      expertise.reload

      expertise
    end
  end
end
