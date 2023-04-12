class CreateCages < ActiveRecord::Migration[6.1]
  def change
    create_table :cages do |t|
      t.string :name
      t.string :status
      t.integer :capacity

      t.timestamps
    end
  end
end
