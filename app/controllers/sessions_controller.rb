class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email( params[:email].downcase )

    if user && user.authenticate(params[:password])
      flash[:success] = "You are now logged in."
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path, :notice => "You are now logged out"
  end
end
