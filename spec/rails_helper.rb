# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")


  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end


def create_author(user, extra_params = nil)
  author_params = attributes_for(:user)
  author_params.merge!(extra_params) if extra_params
  post api_v1_authors_path, params: { author: author_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def update_author(user, author_id, extra_params = nil)
  author_params = { name: 'new_name', surname: 'new_surname'}
  author_params.merge!(extra_params) if extra_params
  patch api_v1_author_path(author_id), params: { author: author_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def destroy_author(user, author_id)
  delete api_v1_author_path(author_id), headers: auth_headers(user)
  JSON.parse(response.body)
end

def create_expertise(user, extra_params = nil)
  expertise_params = attributes_for(:expertise)
  expertise_params.merge!(extra_params) if extra_params
  post api_v1_expertises_path, params: { expertise: expertise_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def update_expertise(user, expertise_id, extra_params = nil)
  expertise_params = { title: 'new_title'}
  expertise_params.merge!(extra_params) if extra_params
  patch api_v1_expertise_path(expertise_id), params: { expertise: expertise_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def destroy_expertise(user, expertise_id)
  delete api_v1_expertise_path(expertise_id), headers: auth_headers(user)
  JSON.parse(response.body)
end


def create_course(user, extra_params = nil)
  course_params = attributes_for(:course)
  course_params.merge!(extra_params) if extra_params
  post api_v1_courses_path, params: { course: course_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def update_course(user, course_id, extra_params = nil)
  course_params = { title: 'new_title'}
  course_params.merge!(extra_params) if extra_params
  patch api_v1_course_path(course_id), params: { course: course_params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def destroy_course(user, course_id)
  delete api_v1_course_path(course_id), headers: auth_headers(user)
  JSON.parse(response.body)
end

def simple_search_course(q)
  get simple_search_api_v1_courses_path, params: { q: q }, headers: auth_headers(user)
  JSON.parse(response.body)
end


def set_like(user,  extra_params = nil)
  params = { item_type: '',
             item_id: '' }
  params.merge!(extra_params) if extra_params
  post like_api_v1_votes_path, params: { vote: params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def set_dislike(user, extra_params = nil)
  params = { item_type: '',
             item_id: '' }
  params.merge!(extra_params) if extra_params
  post dislike_api_v1_votes_path, params: { vote: params }, headers: auth_headers(user)
  JSON.parse(response.body)
end

def unlike(user, extra_params = nil)
  params = { item_type: 'Review',
             item_id: '' }
  params.merge!(extra_params) if extra_params
  post unlike_api_v1_votes_path, params: { vote: params }, headers: auth_headers(user)
  JSON.parse(response.body)
end
