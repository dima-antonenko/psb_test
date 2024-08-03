class Expertise < ApplicationRecord
  has_many :network_logs, as: :logable
end
