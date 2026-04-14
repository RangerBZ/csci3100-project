class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:users, :admin)
      add_column :users, :admin, :boolean, default: false, null: false
    end
  end
end
