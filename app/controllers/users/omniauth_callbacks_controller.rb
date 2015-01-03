class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # This method dynamically defines callback action for each oauth provider, and handles authentication part
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          set_session_data
          redirect_to new_user_registration_url(:redirected_from => "#{provider}")
        end
      end
    }
  end

  # This block calls provides_callback_for method to dynamically generate callback actions for different oauth providers
  [:facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end

  private

  def set_session_data
    provider = env["omniauth.auth"]['provider']
    session["devise.#{provider}_data"] = env["omniauth.auth"]
  end

end
