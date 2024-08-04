class Expertise < ApplicationRecord
  has_many :network_logs, as: :logable

  scope :visible, -> { where(deleted: false).order('created_at DESC') }
  scope :deleted, -> { where(deleted: true).order('created_at DESC') }

  def courses
    Course.where('expertise_ids @> ARRAY[?]', self.id).limit(1000)
  end
end
