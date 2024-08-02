class SupportRequest < ApplicationRecord
  has_many_attached :attachments
  has_many :network_logs, as: :logable
  belongs_to :user, optional: true

  validates :message, presence: true,    length: { minimum: 3, maximum: 5000 }
  validates :name,    allow_blank: true, length: { minimum: 3, maximum: 15 }
  validates :email,   allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
