class AddFlagToPosts < ActiveRecord::Migration[6.1]
  def change
      add_column :users, :role, :string
      add_column :posts, :flag_at, :datetime
  end
end
