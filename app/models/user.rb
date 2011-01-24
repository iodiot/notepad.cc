require 'digest'
class User < ActiveRecord::Base
  attr_accessor :updated_ago
  attr_accessor :password

  before_save :encrypt_password

  def self.authenticate(user_name, submitted_password)
    user = find_by_name(user_name)

    return nil  if user.nil?
    return user if !user.has_password
    return user if user.has_this_password?(submitted_password)
  end

  def has_this_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  private
    def encrypt_password
      return if password == nil
      return if password == ''

      self.has_password = true
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      Digest::SHA2.hexdigest(string)
    end
end

