class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_id, :comment, :created_at
  # アソシエーションの指定
  belongs_to :user,  serializer: UsersSerializer
  belongs_to :post,  serializer: UsersSerializer
end
