class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
  	@posts = Post.paginate(:page => params[:page]).order('updated_at DESC')
  end

  def new
  	@post = current_user.posts.build
  end

  def create
  	@post = current_user.posts.build(post_params)
  	if @post.save
      redirect_to posts_path, notice: 'Sucessfully created post'
  	else
  	  render :new
  	end
  end

  def show
    @comments = @post.comments
  end

  def edit

  end

  def update
    @post.update(post_params)
    redirect_to my_posts_users_path, notice: "Sucessfully Updated post"
  end

  def destroy
    @post.destroy
    redirect_to my_posts_users_path, notice: "Sucessfully Destroy post"
  end

  private
    # this method find post and track post id is valid or not
    def find_post
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_path, alert: 'You not authenticate for this blog.' if @post.blank?
    end

  	def post_params
  		params.require(:post).permit(:text)
  	end
end
