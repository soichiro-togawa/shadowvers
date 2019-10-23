class Kee < ActiveRecord::Migration[5.0]
  def change
    drop_table :dogs
  end
end
