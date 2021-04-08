class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def mark_as_best
    Answer.transaction do
      self.question.answers.where(best: true).first&.update!(best: false)
      self.update!(best: true)
      unless question.reward.nil?
        self.question.reward.update!(user: user)
      end
    end
  end
end
