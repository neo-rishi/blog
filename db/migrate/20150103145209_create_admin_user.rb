class CreateAdminUser < ActiveRecord::Migration
  def change
    User.create(email: 'admin@gmail.com', password: 123456789, admin: true, first_name: 'admin', last_name: 'user')
  end
end
