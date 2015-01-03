class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :find_post, only: [:new, :create, :edit, :show]

  def index
    @comments = Comment.all
  end

  def show

  end

  def new
    @comment = @post.comments.build
  end

  def edit
  end

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to posts_path, notice: "Sucessfully created comment"
    else
      redirect_to new_post_comment_path(params[:comment][:post_id]), alert: "comment can not blank"
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to my_comments_users_path, notice: "Sucessfully updated comment"
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to my_comments_users_path, notice: "comment deleted sucessfully "
  end

  private
     # this method find post and track post id is valid or not
    def find_post
      @post = current_user.posts.find_by_id(params[:post_id])
      redirect_to root_path, alert: 'You not authenticate for this blog.' if @post.blank?
    end
     # this method find comment and track comment id is valid or not
    def set_comment
      @comment = current_user.comments.find_by_id(params[:id])
      redirect_to root_path, alert: 'You not authenticate for this comment.' if @comment.blank?
    end

    def comment_params
      params.require(:comment).permit(:text, :user_id)
    end
end
