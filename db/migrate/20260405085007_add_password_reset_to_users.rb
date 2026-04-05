class AddPasswordResetToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_reset_code, :string
    add_column :users, :password_reset_expires_at, :datetime
  end
end
