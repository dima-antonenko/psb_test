class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include AuthHelper
  include PrettyResponse

  skip_before_action :verify_authenticity_token, if: :json_request?
  prepend_before_action :set_origin, if: Proc.new { Rails.env.production? }

  respond_to :json

  before_action :set_locale

  def set_locale
    if current_user != nil
      I18n.locale = current_user.language
      session[:locale] = current_user.language
    elsif session[:locale] && I18n.available_locales.map { |x| x.to_s }.include?(session[:locale])
      I18n.locale = session[:locale]
    else
      header_locale = extract_locale_from_accept_language_header

      if I18n.available_locales.map { |x| x.to_s }.include?(header_locale)
        I18n.locale = header_locale
        session[:locale] = header_locale
      end
    end
  end

  def extract_locale_from_accept_language_header
    if Rails.env.test?
      'en'
    elsif request.env['HTTP_ACCEPT_LANGUAGE']
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    else
      request.env['CF-IPCountry'].try(:downcase) || 'ru'
    end
  end



  private

  def delay_processing
    sleep 1.4
  end

  def service_success?(service)
    service.is_a?(ActiveRecord::Base)
  end

  def service_has_errors?(service)
    service.is_a?(ActiveModel::Errors)
  end

  # @todo перенести обработку исключений в ExceptionsHelper

  # NoMethodError: undefined method `rescue_from' for ExceptionsHelper:Module

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      # puts "Authenticating from token, token= #{token}, options: #{options}"
      auth_user_impl(options[:email], token)
    end
    auth_user_impl(params[:email], params[:token]) unless current_user
  end

  def auth_user_impl(email, token)
    user = User.find_by(email: email)

    if user && Devise.secure_compare(user.authentication_token, token)
      #bypass_sign_in user
      sign_in user
    end
  end


  def set_origin
    request.headers['origin'] = 'https://mysite.ru'
  end

  rescue_from 'RelationError' do |exception|
    render json: {errors: exception.call}, status: 500
  end

  rescue_from 'PermissionError' do |exception|
    render json: {errors: exception.call}, status: 422
  end

  rescue_from 'ParamsValidationError' do |exception|
    render json: {errors: exception.call}, status: 422
  end

  rescue_from 'ForbiddenError' do |exception|
    render json: {errors: exception.call}, status: 500
  end

  rescue_from 'ActiveRecord::RecordNotFound'  do |exception|
    render json: {errors: 'Record not found'}, status: 404
  end

  def json_request?
    request.format.json?
  end

end
