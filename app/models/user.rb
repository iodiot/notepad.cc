require 'digest'
class User < ActiveRecord::Base
  attr_accessor :updated_ago
  attr_accessor :password

  before_save :encrypt_password

  def self.authenticate(uname, submitted_password)
    user = find_by_name(uname)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def has_password?(submitted_password)
    (encrypted_password == '') or (encrypted_password == encrypt(submitted_password))
  end

  private

    def encrypt_password
      self.encrypted_password = password == '' ? '' : encrypt(password)
    end

    def encrypt(string)
      Digest::SHA2.hexdigest(string)
    end
end

