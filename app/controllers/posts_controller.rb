class PostsController < ApplicationController
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
