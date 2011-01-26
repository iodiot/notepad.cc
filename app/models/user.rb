require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_protected :id, :salt, :hashed_password, :has_password, :password, :login

  validates_uniqueness_of :login
  validates_presence_of :login

  def password=(passwd)
    @password = passwd
    self.has_password = !@password.empty?

    if has_password
      self.salt = User.random_string(10) if !self.salt?
      self.hashed_password = User.encrypt(@password, self.salt)
    else
      self.salt = ''
      self.hashed_password = ''
    end

    self.save
  end

  def self.authenticate(login, passwd)
    user = User.find(:first, :conditions => {:login => login})
    return nil if user.nil?
    return user if !user.has_password
    return user if User.encrypt(passwd, user.salt) == user.hashed_password
    nil
  end

  #
  def self.random_login
    login = ''

    consonant = 'qwrtpsdfghjklzxcvbnm'.split('').to_a
    vowel = 'eyuioa'.split('').to_a
    (1..3).each do
      login << consonant[rand(consonant.size - 1)]
      login << vowel[rand(vowel.size - 1)]
    end

    digits = ('0'..'9').to_a
    (1..2).each { login << digits[rand(digits.size - 1)] }

    return login
  end

  protected

  # Generates a random password consisting of strings and digits
  def self.random_string(length)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    passwd = ""
    1.upto(length) { |i| passwd << chars[rand(chars.size-1)] }
    return passwd
  end

  def self.encrypt(passwd, salt)
    Digest::SHA2.hexdigest(passwd + salt)
  end
end

