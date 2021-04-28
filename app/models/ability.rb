# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], user_id: @user.id
    can :subscribe, Question do |question|
      !question.subscribed?(@user)
    end

    can :unsubscribe, Question do |question|
      question.subscribed?(@user)
    end

    can :destroy, Link do |link|
      @user.author_of? link.linkable
    end

    can %i[vote_up vote_down], [Question, Answer] do |votable|
      @user.id != votable.user.id
    end
    
    can :destroy, ActiveStorage::Attachment do |file|
      @user.author_of? file.record
    end

    can :best, Answer do |answer|
      @user.author_of? answer.question
    end

    can :me, User do |profile|
      profile.id == user.id
    end
  end
end
