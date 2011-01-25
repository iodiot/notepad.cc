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

  def updated_ago
    time_ago(self.updated_at)
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

  def time_ago(from_time, to_time = Time.now, include_seconds = false, detail = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
    when 0..1           then time = (distance_in_seconds < 60) ? "#{distance_in_seconds} seconds ago" : '1 minute ago'
      when 2..59          then time = "#{distance_in_minutes} minutes ago"
      when 60..90         then time = "1 hour ago"
      when 90..1440       then time = "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then time = '1 day ago' # 1-1.5 days
      when 2160..2880     then time = "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5-2 days
      else time = from_time.strftime("%a, %d %b %Y")
    end
    return time_stamp(from_time) if (detail && distance_in_minutes > 2880)
    return time
  end
end

