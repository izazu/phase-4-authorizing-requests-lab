class MembersOnlyArticlesController < ApplicationController
  before_action :authenticate_user

  def index
    if session[:user_id].present?
      articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
      render json: articles, each_serializer: ArticleListSerializer
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def show
    if session[:user_id].present?
      article = Article.find_by(id: params[:id], is_member_only: true)

      if article
        render json: article
      else
        render json: { error: "Member-only article not found" }, status: :not_found
      end
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private

  def authenticate_user
    unless session[:user_id].present?
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end
end
