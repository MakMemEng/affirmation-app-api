class ApplicationController < ActionController::API
  # Cookie を扱う
  include ActionController::Cookies
  # 認可を行う
  include UserAuthenticateService

end
