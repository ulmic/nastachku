class Web::UsersController < Web::ApplicationController
  respond_to :html, :json

  def index
    @search = User.ransack(params)
    @users = @search.result.activated.shown_as_participants.alphabetically

    respond_with(@users)
  end

  def activate
    token = User::AuthToken.find_by_authentication_token!(params[:auth_token])
    user = token.user
    if token && user
      user.activate!
      sign_in user
      flash_success
    else
      flash_error
    end
    redirect_to root_path
  end

end
