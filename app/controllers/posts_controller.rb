class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :destroy]

    def index
      @posts = Post.all
    end
  
    def show
      @post = Post.find(params[:id])
    end
  
    def new
      @post = Post.new
    end
  
    def create
      @post = Post.new(post_params)
      @post.user_id = current_user.id      
      if @post.save
        redirect_to @post
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @post = Post.find(params[:id])
    end
  
    def update
      @post = Post.find(params[:id])
  
      if @post.update(post_params)
        redirect_to @post
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post = Post.find(params[:id])
      @post.destroy
  
      redirect_to root_path, status: :see_other
    end
  
  private

    def set_post
      @post = Post.find(params[:id])
    end

    def authorize_user!
      unless @post.user == current_user
        redirect_to posts_url, alert: 'You are not authorized to perform this action.'
      end
    end

    def post_params
        params.require(:post).permit(:title, :body)
    end

  
end
