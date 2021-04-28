class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :questions_users, dependent: :destroy
  has_many :subscriptions, through: :questions_users, source: :question

  def author_of?(obj)
    self.id == obj.user.id
  end
end
