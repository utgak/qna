class Question < ApplicationRecord
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :questions_users, dependent: :destroy
  has_many :subscribers, through: :questions_users, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_for_question

  def subscribed?(user)
    subscribers.where(id: user).exists?
  end

  private

  def subscribe_for_question
    subscribers << user
  end
end
