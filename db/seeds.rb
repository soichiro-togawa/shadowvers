# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dog.delete_all

require "csv"
 
CSV.foreach('db/dogs.csv', headers: true) do |row|
  Dog.create(idd: row['idd'],
             classid: row['classid'],
             level: row['level'],
             line: row['line'],
             eline: row['eline'],
             priority: row['priority'],
             kind1: row['kind1'],
             kind2: row['kind2'],
             manalimit: row['manalimit'],
             manamin: row['manamin'],
             content: row['content'],
             evolve: row['evolve'],
             bold1: row['bold1'],
             bold2: row['bold2'],
             bold3: row['bold3'],
             bold4: row['bold4']
             )
end

