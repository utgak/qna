# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], user_id: @user.id

    can :destroy, Link do |link|
      @user.id == link.linkable.user.id
    end

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      @user.id != votable.user.id
    end
    
    can :destroy, ActiveStorage::Attachment do |file|
      @user.id == file.record.user.id
    end

    can :best, Answer do |answer|
      @user.id == answer.question.user.id
    end
  end
end
