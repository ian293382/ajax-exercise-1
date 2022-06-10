class PostsController < ApplicationController

 before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

  def destroy
    @post = current_user.posts.find(params[:id]) # 只能刪除自己的貼文
    @post.destroy

  end

  protected

  def post_params
    params.require(:post).permit(:content)
  end
end
