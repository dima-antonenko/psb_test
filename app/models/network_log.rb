class NetworkLog < ApplicationRecord
  belongs_to :logable, polymorphic: true, optional: true
  belongs_to :user, optional: true
end
