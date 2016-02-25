class CreateUserSearchTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password


      t.timestamps null:false
    end


    create_table  :searches do |t|
      t.string :starting_location
      t.string :ending_location
      t.integer :price
      t.date :days
      t.references :user 


      t.timestamps null:false
    end
  end




end


