class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :default => nil
  end
  def self.down
    remove_column :username
  end
end
