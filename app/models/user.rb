class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  scope :visible, -> { where(deleted: false).order('created_at DESC') }
  scope :deleted, -> { where(deleted: true).order('created_at DESC') }

  before_save :ensure_authentication_token

  has_many :network_logs
  has_many :support_requests
  has_many :appeals, as: :appealable
  has_many :courses

  validates :name, length: { minimum: 2, maximum: 15 }, allow_blank: false
  validates :surname, length: { minimum: 2, maximum: 15 }, allow_blank: true
  validates :language, inclusion: %w[ru en]

  has_paper_trail only: [:name, :surname], on: [:update]

  private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
