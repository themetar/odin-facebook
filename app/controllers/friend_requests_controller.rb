class FriendRequestsController < ApplicationController
  def index
    unless current_user.nil?
      @friend_offers = current_user.friend_offers.pending
      @friend_requests = current_user.friend_requests.pending
    else
      @friend_offers = @friend_requests = FriendRequest.none
    end
  end

  def create
    friend_request = current_user.friend_requests.build(requestee_id: params[:friend_id], accepted: false)
    if friend_request.save
      friend = User.find(params[:friend_id])
      flash[:success] = "Friend request sent to #{friend.name}."
      redirect_back fallback_location: users_path
    else
      flash.now[:error] = "An error has occured"
    end
  end

  def update
    friend_request = FriendRequest.find params[:id]
    friend_request.update(accepted: params[:accepted])
    redirect_back fallback_location: friend_requests_path
  end

  def destroy
    friend_request = FriendRequest.find params[:id]
    friend_request.destroy
    redirect_back fallback_location: friend_requests_path
  end
end
