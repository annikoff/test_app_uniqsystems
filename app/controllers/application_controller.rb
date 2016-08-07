class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index, :show]
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :find_categories
  before_action :find_tags

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end

  def find_categories
    @categories = Category.all.sort
  end

  def find_tags
    @tags = Tag.all
  end
end
