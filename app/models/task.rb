class Task < ApplicationRecord
  belongs_to :list
  validates :title, presence: true
  validates :status, presence: true
end
