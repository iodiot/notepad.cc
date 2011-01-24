module SessionsHelper

  def sign_in(user)
    cookies[:remember_token] = {:value => user.encrypted_password, :expires => Time.now + 3600}
  end

  def signed_in?(user)
    cookies[:remember_token] == user.encrypted_password
  end

  def sign_out
    cookies.delete(:remember_token)
  end

end

