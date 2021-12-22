class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user
  before_action :set_post, only: %i[update destroy]

  # N+1問題の対応
  def index
    posts = Post.includes(:user).order(created_at: :desc).limit(10)
    # @posts = Post.includes(:user).order(id: "DESC").page(params[:page]).per(25)
    render json: posts, each_serializer: PostsSerializer
  end

  # def show
  #   @post = Post.find_by(params[:id])
  #   unless @post.nil?
  #     render json: @post
  #   else
  #     render json: { errors: post.errors }, status: 404
  #   end
  # end

  def create
    post = current_user.posts.new(post_params)
    if post.save
      render json: '作成に成功しました', status: 200
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  def destroy
    @post.destroy
    render json: @post
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :body, :created_at, :updated_at)

    # params.permit(:title, :body, :image_id, :user_id, :created_at, :updated_at)
  end

end
