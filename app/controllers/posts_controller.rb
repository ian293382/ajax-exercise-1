class PostsController < ApplicationController

 before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").limit(20)

    if params[:max_id]
      @posts = @posts.where( "id < ?", params[:max_id])
    end

    respond_to do |format|
      format.html #客戶要求HTML 則回傳 index
      format.js   #客戶端要求 JavaScript 回傳 index.js.erb
    end
  end


  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

def update
  @post = Post.find(params[:id])
  @post.update!( post_params )
  render :json => { :id => @post.id, :message => "ok"}
end

  def destroy
    @post = current_user.posts.find(params[:id]) # 只能刪除自己的貼文
    @post.destroy

      render :json => { :id => @post.id }
  end

  def like
     @post = Post.find(params[:id])
     unless @post.find_like(current_user)  # 如果已經按讚過了，就略過不再新增
       Like.create( :user => current_user, :post => @post)
     end

   end

   def unlike
     @post = Post.find(params[:id])
     like = @post.find_like(current_user)
     like.destroy

     render "like"
   end

   def toggle_flag
     @post = Post.find(params[:id])

     if @post.flag_at
       @post.flag_at = nil
     else
       @post.flag_at = Time.now
     end

     @post.save!

     render :json => { :message => "ok", :flag_at => @post.flag_at, :id => @post.id }
   end

  protected

  def post_params
    params.require(:post).permit(:content)
  end
end
