class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validate :validate_vote_once, on: :create, if: Proc.new { self.user }

  private

  def validate_vote_once
    if votable.votes.where(user: user, value: value).exists?
      votable.errors.add :user, :user_not_uniq, message: 'have already voted'
    end
  end
end
