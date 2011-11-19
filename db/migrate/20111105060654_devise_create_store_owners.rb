class DeviseCreateStoreOwners < ActiveRecord::Migration
  def self.up
    create_table(:store_owners) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :store_owners, :email,                :unique => true
    add_index :store_owners, :reset_password_token, :unique => true
    # add_index :store_owners, :confirmation_token,   :unique => true
    # add_index :store_owners, :unlock_token,         :unique => true
    # add_index :store_owners, :authentication_token, :unique => true
  end

  def self.down
    drop_table :store_owners
  end
end
