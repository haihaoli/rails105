class Group < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  has_many :posts
  accepts_nested_attributes_for :posts, :allow_destroy => true, :reject_if => :all_blank

  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user
end
