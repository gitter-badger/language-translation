class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def regenerate_api_key
    current_user.reset_authentication_token!
    current_user.reload

    respond_with(current_user) do |format|
      format.html { redirect_to edit_user_registration_path }
    end
  end

  private

  # check if we need password to update user data
  # ie if password or username was changed
  # extend this as needed
  def needs_password?(user, params)
    user.username != params[:user][:username] ||
      params[:user][:password].present?
  end
end
