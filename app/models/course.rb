class Course < ApplicationRecord
  include PgSearch::Model

  has_many :network_logs, as: :logable
  has_many :appeals, as: :appealable

  belongs_to :user

  scope :visible, -> { where(deleted: false).order('created_at DESC') }
  scope :deleted, -> { where(deleted: true).order('created_at DESC') }

  def expertises
    Expertise.visible.where(id: self.expertise_ids).limit(1000)
  end

  pg_search_scope :simple_search,
                  against: [:search_meta_data],
                  using: { trigram: { word_similarity: true, threshold: 0.5 } }
end
