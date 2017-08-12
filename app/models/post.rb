class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :favors, dependent: :destroy
  has_many :favored_users, through: :favors, source: :user
  belongs_to :category, :optional => true

  has_many :scores, :class_name => "PostScore"
  def find_like(user)
    self.likes.where(user_id: user.id).first
  end
  
  def find_favor(user)
    self.favors.where(user_id: user.id).first
  end
  
  def find_score(user)
    user && self.scores.where( :user_id => user.id ).first
  end

  def average_score
    self.scores.average(:score)
  end
end
