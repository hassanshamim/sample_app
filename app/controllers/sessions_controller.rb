class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email( params[:session][:email].downcase )

    if user && user.authenticate(params[:session][:password])
      flash[:success] = "You are now logged in."
      sign_in user
      redirect_to user
    else
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
     sign_out
    flash.notice = "You are now logged out"
    redirect_to root_path
  end
end