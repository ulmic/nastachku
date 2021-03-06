class Web::SessionsController < Web::ApplicationController

  def new
    if params[:auth_token]
      token = User::AuthToken.find_by_authentication_token params[:auth_token]
      if token
        user = token.user
        @email = user.email
      end
    end

    @type = UserSignInType.new
  end

  def create
    @type = UserSignInType.new params[:user_sign_in_type]
    if @type.valid?
      user = @type.user
      flash_success
      sign_in user
      if params[:from] == registrator_root_url
        redirect_to registrator_root_url
      else
        redirect_to auth_cs_cart_user_url get_auth_token user
      end
    else
      flash[:error] = @type.errors.full_messages
      redirect_to new_session_path
    end
  end

  def destroy
    sign_out
    redirect_to welcome_index_path
  end

end
