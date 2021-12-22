class PostsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  # アソシエーションの指定
  belongs_to :user,  serializer: UsersSerializer
end
