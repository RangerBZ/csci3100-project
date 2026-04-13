class AddReserverIdToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :reserver_id, :integer
  end
end
