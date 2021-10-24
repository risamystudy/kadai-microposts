class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user     #自分じゃないか
      self.relationships.find_or_create_by(follow_id: other_user.id)
      #selfにはuser.follow(other)実行でuserが代入される
      #見つかればRelationshipクラスのインスタンスを返し、見つからなければcreateでフォロー関係を保存するcreate=build+save
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id) #フォローしているかどうか
    relationship.destroy if relationship #フォローがあったときに破棄する
  end
  
  def following?(other_user)
    self.followings.include?(other_user) #other_userが含まれているtrue、含まれていないfalse
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end