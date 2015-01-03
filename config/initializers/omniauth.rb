Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "258207452694-0k8geqrfpj0j2iuf1vug1d1movbuucb9.apps.googleusercontent.com", "Spz_YPZyojX1of8sQ9VijaNz"
   provider :facebook, '1480391125545892', 'dcc18f2438daf7b89d7e10a4b542b769',
           :scope => 'email,user_birthday,read_stream'
end
