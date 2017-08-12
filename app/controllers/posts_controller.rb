class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  # skip_before_action :verify_authenticity_token, only: [:destroy, :toggle_flag, :update]
  
  def index
    @posts = Post.order('id DESC').limit(20)
    
    if params[:max_id]
      @posts = @posts.where('id < ?', params[:max_id])
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
  end
  
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    
    render json: { id: @post.id }
  end
  
  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)
      Like.create(user: current_user, post: @post)
    end
  end
  
  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy
    render 'like'
  end

  def favor
    @post = Post.find(params[:id])
    unless @post.find_favor(current_user)
      Favor.create(user: current_user, post: @post)
    end
  end
  
  def unfavor
    @post = Post.find(params[:id])
    favor = @post.find_favor(current_user)
    favor.destroy
    render 'favor'
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

  def update
    sleep(1)
    @post = Post.find(params[:id])
    @post.update!( post_params )
    render :json => { :id => @post.id, :message => "ok"}
  end

  def rate
    @post = Post.find(params[:id])
  
    existing_score = @post.find_score(current_user)
    if existing_score
      existing_score.update( :score => params[:score] )
    else
      @post.scores.create( :score => params[:score], :user => current_user )
    end
  
    render :json => { :average_score => @post.average_score }
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content, :category_id)
  end
end
