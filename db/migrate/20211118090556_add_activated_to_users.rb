class AddActivatedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activated, :boolean, default: false, null: false
  end
end
