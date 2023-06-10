class CreateUsersAndSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name

      t.timestamps
    end

    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in
      t.datetime :clock_out
      t.integer :duration

      t.timestamps
    end
  end
end
