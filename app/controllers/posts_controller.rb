class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.all

    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: "反省しました"
    else
      flash[:alert] = "反省できませんでした"
      render :new
    end
  end

  def edit
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to posts_path, success: "投稿を削除しました"
  end

  def update
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end
