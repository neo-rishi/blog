class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2, :facebook]
  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :identity, dependent: :destroy

  validates_presence_of :first_name, :last_name

   def full_name
   	first_name + ' '+last_name
   end

   class << self

    # This method returns a user object by finding/creating a user after being authenticated from google
    def find_for_oauth(access_token, signed_in_resource=nil)

      case access_token['provider']
      when 'google_oauth2'
        user_email = access_token['extra']['raw_info']['email']
      when 'facebook'
        user_email = access_token['extra']['raw_info']['email']
      else
        user_email = nil
      end
      if user_email
        if User.where(:email => user_email).exists?
          user = User.find_by(email: user_email)
          user.identity.where(provider: access_token['provider'], uid: access_token['uid']).first_or_create
        end
      else
        user = Identity.find_by(provider: access_token['provider'], uid: access_token['uid']).try(:user)
      end
      unless user
        user = eval("initialize_user_for_#{access_token['provider']}(access_token)")
      end
      user
    end


    def initialize_user_for_google_oauth2(access_token)
      data = access_token['extra']['raw_info']
      user = User.create(
        first_name: data["given_name"],
        last_name: data["family_name"],
        email: data["email"],
        password: Devise.friendly_token[0,20],
        refresh_token: access_token['credentials']['refresh_token']
      )
      user.identity.build(
        provider: access_token['provider'],
        uid: access_token['uid']
      )
      user
    end

    def initialize_user_for_facebook(access_token)
      data = access_token['extra']['raw_info']
      user = User.create(
        first_name: data["name"],
        last_name: '',
        email: data["email"],
        password: Devise.friendly_token[0,20],
        refresh_token: access_token['credentials']['refresh_token']
      )
      user.identity.build(
        provider: access_token['provider'],
        uid: access_token['uid']
      )
      user
    end

    # Initializes the new user from session.
    # This method is used by devise internally for initializing resource from session to use on sign up form
    def new_with_session(params, session)
      if session['devise.google_oauth2_data']
        super.tap do |user|
          if data = session["devise.google_oauth2_data"] && session["devise.google_oauth2_data"]["info"]
            user.email = data["email"] if user.email.blank?
            user.first_name = data['first_name']
            user.last_name = data['last_name']
            user.identity.first_or_initialize(
              provider: session["devise.google_oauth2_data"]['provider'],
              uid: session["devise.google_oauth2_data"]['uid']
            )
          end
        end

      elsif session['devise.facebook_data']
        super.tap do |user|
          if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
            user.email = data["email"] if user.email.blank?
            user.first_name = data['first_name']
            user.last_name = data['last_name']
            user.identity.first_or_initialize(
              provider: session["devise.facebook_data"]['provider'],
              uid: session["devise.facebook_data"]['uid']
            )
          end
        end
      else
        new(params)
      end
    end

  end
end
