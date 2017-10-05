class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :fax_tag, null: false
      t.string :fax_number, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
