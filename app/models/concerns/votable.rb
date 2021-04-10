module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  
  def vote_up(user)
    if votes.where(user: user, option: 'up').exists?
      errors.add :user, :user_not_uniq, message: 'have already voted'
    else
      transaction do
        previous_vote = votes.where(user: user, option: 'down')

        previous_vote.first.destroy! if previous_vote.exists?
        votes.create!(user: user, option: 'up')
      end
    end
  end

  def vote_down(user)
    if votes.where(user: user, option: 'down').exists?
      errors.add :user, :user_not_uniq, message: 'have already voted'
    else
      transaction do
        previous_vote = votes.where(user: user, option: 'up')

        previous_vote.first.destroy! if previous_vote.exists?
        votes.create!(user: user, option: 'down')
      end
    end
  end

  def voting_result
    votes.where(option: 'up').count - votes.where(option: 'down').count
  end
end
