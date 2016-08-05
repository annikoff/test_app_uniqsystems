class PostsController < ApplicationController
  before_action :find_categories
  before_action :find_post, :only => [:edit, :update, :show, :destroy]

  def index
    @posts = Post.includes(:category, :tags).all
  end

  def show
  end

  def edit
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(resource_params)
    if @post.save
      flash[:notice] = 'Post successfully created'
      redirect_to root_path
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  def update
    if @post.update(resource_params)
      flash[:notice] = 'Post successfully updated'
      redirect_to post_path(@post)
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = 'Post successfully destroyed'
      redirect_to root_path
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  private

  def resource_params
    params.require(:post).permit(:title, :body, :category_id)
  end

  def find_post
    @post = Post.find_by_id params[:id]
    render 'error_404', status: 404 if @post.blank?
  end

  def find_categories
    @categories = Category.all
  end
end
