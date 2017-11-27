class AddRecentCitiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recent_cities, :string
  end
end
