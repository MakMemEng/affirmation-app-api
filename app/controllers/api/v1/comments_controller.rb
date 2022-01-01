class Api::V1::CommentsController < ApplicationController

  def index
    comment = Comment.where(post_id: params[:post_id]).order('id DESC')
    render json: { status: 200, comment: comment, message: "コメント一覧を取得しました" }
    # render json: comment, each_serializer: CommentsSerializer
  end

  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id
    if comment.save
      render json: '作成に成功しました', status: 200
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  def destroy
    comment = Comment.find(id: params[:id], post_id: params[:post_id])
    comment.destroy
    render :destroy
    redirect_to post_path(comment.user)
  end

  private

  def comment_params
    params.permit(:comment, :created_at, :updated_at).merge(user_id: current_user.id, post_id: params[:post_id])
    # params.require(:comment).permit(:post_id).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
