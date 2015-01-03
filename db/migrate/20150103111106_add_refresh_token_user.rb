class AddRefreshTokenUser < ActiveRecord::Migration
  def self.up
    add_column :users, :refresh_token, :string
  end

  def self.down
    remove_column :users, :refresh_token
  end
end
