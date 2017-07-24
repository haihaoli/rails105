class Post < ApplicationRecord
  validates :content, presence: true

  belongs_to :group
  belongs_to :user

  scope :recent, -> { order("created_at DESC")}

  include RankedModel
  ranks :row_order
end
