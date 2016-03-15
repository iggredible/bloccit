require 'random_data'

class CommentsController < ApplicationController

  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
  #  @topic = Topic.find(params[:topic_id])
  #  comment_topic = @topic.comments.new(comment_params)
  #  comment_topic.user = current_user
    if params[:post_id]
      @post = Post.find(params[:post_id])
      comment_post = @post.comments.new(comment_params)
      comment_post.user = current_user

      if comment_post.save
        flash[:notice] = "Comment saved successfully."
        redirect_to [@post.topic, @post]
      else
        flash[:alert] = "Comment failed to save."
        redirect_to [@post.topic, @post]
      end
    elsif params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      comment_topic = @topic.comments.new(comment_params)
      comment_topic.user = current_user

      if comment_topic.save
       flash[:notice] = "Comment saved successfully."
       redirect_to topics_path
      else
       flash[:alert] = "Comment failed to save."
       redirect_to topics_path
      end
    end
  end

  def destroy

    if params[:post_id]
      @post = Post.find(params[:post_id])
      comment_post = @post.comments.find(params[:id])

      if comment_post.destroy
        flash[:notice] = "Comment was deleted."
        redirect_to [@post.topic, @post]
      else
        flash[:alert] = "Comment could not be deleted. Try again!"
        redirect_to [@post.topic, @post]
      end
    else

     @topic = Topic.find(params[:topic_id])
     comment_topic = @topic.comments.find(params[:id])
      if comment_topic.destroy
        flash[:notice] = "Comment was deleted."
        redirect_to topics_path
      else
        flash[:alert] = "Comment could not be deleted. Try again!"
        redirect_to topics_path
      end
    end
  end

  private


  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You don't own this comment nor you are a moderator"
      redirect_to [comment.post.topic, comment.post]
    end
  end
end
