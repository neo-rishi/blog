class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :create_identity
  # after_action :verify_authorized

  def show
    @user = User.find(params[:id])
    # authorize @user
  end

  def my_posts
    @posts = current_user.posts.paginate(:page => params[:page]).order('updated_at DESC')
  end

  def my_comments
    @comments = current_user.comments.paginate(:page => params[:page]).order('updated_at DESC')
  end

  # Here we create an identity for user so that that user can be identified next time with this identity from database
  def create_identity
    user = User.find_by(email: params[:user][:email])
    if user.update(user_params)
      sign_in('user', user)
      redirect_to user_profile_path(user), notice: 'Information stored successfully.'
      clear_omniauth_data
    else
      redirect_to(
        new_user_registration_path(:redirected_from => params[:user][:identity_attributes][:provider]),
        error: "Could not update information due to : #{user.errors.full_messages.join(', ')}"
      )
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      identity_attributes: [
        :provider,
        :uid
      ]
    )
  end

  def clear_omniauth_data
    session['devise.google_oauth2_data'], session['devise.facebook_data'] = nil
  end

end

