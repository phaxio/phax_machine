class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :fax_number, null: false
      t.timestamps
    end
  end
end
