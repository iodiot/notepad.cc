class AddHasPasswordToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :has_password, :boolean
  end

  def self.down
    remove_column :users, :has_password
  end
end
