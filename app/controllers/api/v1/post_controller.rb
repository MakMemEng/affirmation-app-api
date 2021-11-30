class Api::V1::PostController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  # # N+1問題の対応
  # def index
  #   @posts = Post.preload(:users)
  #   render json: @posts, each_serializer: PostsSerializer
  # end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post, each_serializer: PostsSerializer
    else
      render json: @post.errors, status: 500
  　end
  end

  private

  def post_params
    params.permit(:id, :name)
  end

end
