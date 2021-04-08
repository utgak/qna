class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :img

  validates :img, presence: true, blob: { content_type: :image }
  validates :name, presence: true
end
