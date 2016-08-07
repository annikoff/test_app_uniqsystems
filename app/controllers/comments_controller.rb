class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :find_post, :only => [:create, :destroy]
  before_action :find_comment, :only => [:accept, :decline, :destroy]
  before_action :check_access, :only => [:accept, :decline, :destroy]
  self.view_paths = "app/views"

  def create
    @comment = Comment.new(resource_params)
    @comment.post = @post
    @comment.user = current_user
    if (current_user.present? || verify_recaptcha(model: @comment)) && @comment.save
      flash[:notice] = 'Comment successfully created'
      if !current_user.try(:is_admin?)
        flash[:notice] += '. It would be shown after moderation'
      end
      redirect_to post_path(@post)
    else
      flash[:alert] = @comment.errors.full_messages
      render 'posts/show', status: 422
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = 'Comment successfully destroyed'
      redirect_to post_path(@comment.post)
    else
      flash[:alert] = @comment.errors.full_messages
      render 'posts/show', status: 422
    end
  end

  def accept
    if @comment.update(is_accepted: true)
      flash[:notice] = 'Comment successfully accepted'
      redirect_to post_path(@comment.post)
    else
      flash[:alert] = @comment.errors.full_messages
      render 'posts/show', status: 422
    end
  end

  def decline
    if @comment.update(is_accepted: false)
      flash[:notice] = 'Comment successfully declined'
      redirect_to post_path(@comment.post)
    else
      flash[:alert] = @comment.errors.full_messages
      render 'posts/show', status: 422
    end
  end

  private

  def resource_params
    params.require(:comment).permit(:body)
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
    render 'error_404', status: 404 if @post.blank?
  end

  def find_comment
    @comment = Comment.find_by_id params[:id]
    render 'error_404', status: 404 if @comment.blank?
  end

  def check_access
    render 'error_403', status: 403 unless current_user.try(:is_admin?)
  end
end
