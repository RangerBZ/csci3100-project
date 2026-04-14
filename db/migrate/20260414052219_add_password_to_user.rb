class AddPasswordToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password, :string unless column_exists?(:users, :password)
  end
end
