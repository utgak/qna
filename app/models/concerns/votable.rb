module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  
  def vote_up(user)
    transaction do
      votes.where(user: user, value: -1).first&.destroy!
      votes.create!(user: user, value: 1)
    end
  end

  def vote_down(user)
    transaction do
      votes.where(user: user, value: 1).first&.destroy!
      votes.create!(user: user, value: -1)
    end
  end

  def voting_result
    votes.sum(:value)
  end
end
