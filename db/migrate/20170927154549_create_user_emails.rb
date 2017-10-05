class CreateUserEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :user_emails do |t|
    	t.integer  :user_id
    	t.string   :email
    	t.timestamps
    end
  end
end
