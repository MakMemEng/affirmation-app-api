class UsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  # アソシエーションの指定
  has_many :posts, serializer: PostsSerializer
end
