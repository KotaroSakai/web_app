class PostsController < ApplicationController
  def index
    @posts = Post.all

    @post = Post.new
  end

  def create
    current_user.posts.build(post_params)
    @posts = Post.all
  end

  def edit
  end

  def destroy
  end

  def update
  end

  def show
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end
