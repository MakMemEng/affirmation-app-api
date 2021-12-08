class PostsSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at

  # アソシエーションの指定
  belongs_to :user,  serializer: UsersSerializer
end
