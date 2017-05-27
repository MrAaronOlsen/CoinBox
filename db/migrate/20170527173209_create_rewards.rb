class CreateRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :desc
      t.integer :cost, default: 0, null: false

      t.timestamps
    end
  end
end
