class CreateUserFaxNumbers < ActiveRecord::Migration[5.1]
  def up
    create_table :user_fax_numbers do |t|
    	t.references :user, null: false
    	t.string :fax_number, null: false
    	t.boolean :primary_number, null: false, default: true
    	
    	t.timestamps
    end

    User.find_each do |user|
    	fax_number = UserFaxNumber.create!(fax_number: user.fax_number, user_id: user.id)
    end

    remove_column :users, :fax_number
  end

  def down
  	drop_table :user_fax_numbers
  	add_column :users, :fax_number, :string
  end
end
