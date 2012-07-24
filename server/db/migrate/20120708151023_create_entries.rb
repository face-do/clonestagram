class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :avatar
      t.references :user
      
      t.timestamps
    end
  end
end
