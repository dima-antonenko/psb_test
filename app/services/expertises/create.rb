module Expertises
  class Create < BaseService
    include UserValidations
    include ExpertiseValidations
    attr_accessor :user, :params, :expertise, :request

    def initialize(user, params, request)
      @user = user
      @params = params
      @expertise = Expertise.new
      @request = request
    end

    def call
      validate!
      assign!
      save_expertise(expertise, request)
    end

    private

    def validate!
      user_active?(user)
    end

    def assign!
      expertise.assign_attributes(params)
    end

    def save_expertise(expertise, request)
      return expertise.errors unless expertise.valid?
      ActiveRecord::Base.transaction do
        expertise.save!
        expertise.network_logs.create(user_id: user.id,
                                      event_type: 'create_expertise',
                                      ip: request.remote_ip,
                                      user_agent: request.user_agent,
                                      logable_id: expertise.id)
      end
      expertise.reload
      expertise
    end
  end
end
