class AddFaxTagToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :fax_tag, :string
    User.find_each(batch_size: 100) do |user|
      user.update! fax_tag: user.email
    end
    change_column_null :users, :fax_tag, false
    add_index :users, :fax_tag
  end

  def down
    remove_column :users, :fax_tag
  end
end
