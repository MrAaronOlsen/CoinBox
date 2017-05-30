class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :first_name, default: 'first name'
      t.string :last_name, default: 'last name'
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
