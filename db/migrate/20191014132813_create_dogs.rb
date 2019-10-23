class CreateDogs < ActiveRecord::Migration[5.0]
  def change
    create_table :dogs do |t|
      t.integer :idd
      t.integer :classid
      t.integer :level
      t.integer :line
      t.integer :eline
      t.integer :priority
      t.string :kind1
      t.string :kind2
      t.integer :manalimit
      t.integer :manamin
      t.text :content
      t.text :evolve
      t.string :bold1
      t.string :bold2
      t.string :bold3
      t.string :bold4

      t.timestamps
    end
  end
end
