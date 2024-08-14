module Expertises
  class Destroy < BaseService
    include UserValidations
    include ExpertiseValidations

    attr_accessor :user, :expertise, :request

    def initialize(user, expertise, request)
      @user = user
      @expertise = expertise
      @request = request
    end

    def call
      validate!
      expertise.assign_attributes({ deleted: true })
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
        expertise.network_logs.create(user_id: expertise.id,
                                      event_type: 'destroy_expertise',
                                      ip: request.remote_ip,
                                      user_agent: request.user_agent,
                                      logable_id: expertise.id)
      end
      expertise.reload
      remove_from_related_courses!
      expertise
    end

    # в перспективе перенести в CRON
    def remove_from_related_courses!
      expertise.courses.select(:id, :expertise_ids).each do |c|
        c.expertise_ids.delete(expertise)
        c.save
      end
    end
  end
end
