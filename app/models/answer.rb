class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def mark_as_best
    transaction do
      question.answers.where(best: true).first&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
