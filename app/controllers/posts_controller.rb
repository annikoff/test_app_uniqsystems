class PostsController < ApplicationController
  before_action :find_post, :only => [:edit, :update, :show, :destroy]
  before_action :find_category
  before_action :find_tag
  before_action :find_order
  before_action :check_access, :except => [:index, :show]
  include PostsHelper

  def index
    @search = url_params[:search]
    scope = Post.joins(:category, :tags)
    scope = case
              when @category.present?
                scope.where(categories: { id: @category.id })
              when @tag.present?
                scope.where(taggings: { tag_id: @tag.id })
              when @search
                scope.where("posts.title LIKE '%#{@search}%' OR posts.body LIKE '%#{@search}%'")
              else
                scope
            end
    @posts = scope.order("posts.created_at #{@order}").distinct
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
      flash[:success] = 'Post successfully created'
      redirect_to root_path
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  def update
    if @post.update(resource_params)
      flash[:success] = 'Post successfully updated'
      redirect_to post_path(@post)
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = 'Post successfully destroyed'
      redirect_to root_path
    else
      flash[:alert] = @post.errors.full_messages
      render 'new', status: 422
    end
  end

  private

  def resource_params
    params.require(:post).permit(:title, :body, :category_id, tag_ids: [], tag_names: [])
  end

  def find_post
    @post = Post.find_by_id params[:id]
    render 'application/error_404', status: 404 if @post.blank?
  end

  def find_tag
    @tag = Tag.find_by_name params[:tag] if params[:tag].present?
  end

  def find_category
    @category = Category.find_by_name params[:category] if params[:category].present?
  end

  def find_order
    @order = url_params['order'].in?(['asc', 'desc']) ? params['order'] : 'desc'
  end

  def check_access
    render 'application/error_403', status: 403 unless current_user.try(:is_admin?)
  end
end
