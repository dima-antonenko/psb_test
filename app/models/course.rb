class Course < ApplicationRecord
  has_many :network_logs, as: :logable
  has_many :appeals, as: :appealable

  belongs_to :user

  scope :visible, -> { where(deleted: false).order('created_at DESC') }
  scope :deleted, -> { where(deleted: true).order('created_at DESC') }

  def expertises
    Expertise.visible.where(id: self.expertise_ids).limit(1000)
  end
end
