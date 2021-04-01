class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def mark_as_best
    self.question.answers.where(best: true).first&.update!(best: false)
    self.update!(best: true)
  end
end
