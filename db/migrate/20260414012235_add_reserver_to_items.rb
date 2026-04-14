class AddReserverToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :reserver_id, :integer unless column_exists?(:items, :reserver_id)
    add_index :items, :reserver_id unless index_exists?(:items, :reserver_id)
  end
end
