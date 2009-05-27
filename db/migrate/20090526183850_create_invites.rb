class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites, :force => true do |t|
      t.string :slug
      t.datetime :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end