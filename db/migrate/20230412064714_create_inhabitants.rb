class CreateInhabitants < ActiveRecord::Migration[6.1]
  def change
    create_table :inhabitants do |t|

      t.string :name
      t.string :species
      t.string :diet
      t.string :group
      t.references :cage, null: true, foreign_key: true

      t.timestamps
    end
  end
end
