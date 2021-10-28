class FavoritesController < ApplicationController
#ログインは必要？
  #before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'お気に入りに登録しました'
    redirect_to request.referer
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:danger] = 'お気に入りを解除しました'
    redirect_to request.referer
  end
end
