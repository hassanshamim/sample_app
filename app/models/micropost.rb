# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by( user )
    followed_user_ids = user.followed_user_ids << user.id
    self.where( user_id: followed_user_ids )
  end

  #Hartl's guide uses string interpolation on the SQL query, like follows.
  #is adding the user's id to the followed_user_ids array less secure?
  # - I think this was done to make it into 1 query with a subselect
  #
  # def self.from_users_followed_by(user)
  # followed_user_ids = "SELECT followed_id FROM relationships
  #                      WHERE follower_id = :user_id"
  # where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
  #       user_id: user.id)
  # end
end
