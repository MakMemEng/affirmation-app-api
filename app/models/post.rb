class Post < ApplicationRecord
  belongs_to :user
  attachment :image

  with_options presence: true do
    validates :title,     length: { maximum: 30 }
    validates :body,      length: { maximum: 400 }
    # validates :image
    validates :user_id
  end
end
