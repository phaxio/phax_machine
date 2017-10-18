class CreateUserEmails < ActiveRecord::Migration[5.1]
  def up
    create_table :user_emails do |t|
      t.references :user, null: false
      t.string :email, null: false
      t.timestamps
      t.index :email, name: 'index_user_emails_by_email'
    end

    User.find_each(batch_size: 100) do |user|
      duplicates = User.where(fax_number: user.fax_number).where.not(id: user.id)
      parent = duplicates.find { |duplicate| duplicate.user_emails.any? }
      if parent
        parent.user_emails.create! user: parent, email: user.email
        user.destroy
      else
        user.user_emails.create! user: user, email: user.email
      end
    end

    remove_column :users, :email
  end

  def down
    drop_table :user_emails
    add_column :users, :email, :string
  end
end
