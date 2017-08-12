class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :likes
  has_many :liked_posts, through: :likes, source: :post
  has_many :favors
  has_many :favored_posts, through: :favors, source: :post
  
  def display_name
    self.email.split('@').first
  end
  
  def is_admin?
    role == 'admin'
  end
end