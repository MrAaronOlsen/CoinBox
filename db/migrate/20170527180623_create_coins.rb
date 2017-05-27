class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
      t.integer :denom
      t.references :user_reward, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
