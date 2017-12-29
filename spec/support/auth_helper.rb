module AuthHelper
  def http_login
    spoof_env_vars
    user = 'pdf_server'
    pw = 'api_key'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  end

  def spoof_env_vars
    allow(ENV).to receive(:fetch).with('API_KEY').and_return('api_key')
    allow(ENV).to receive(:fetch).with('SERVICE_NAME').and_return('pdf_server')
  end
end
