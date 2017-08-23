class CreateUsersMigration
  def up
    DB.create_table :users do
      primary_key :id
      String :email
      String :fax_number
    end
  end

  def down
    DB.drop_table :users
  end
end
