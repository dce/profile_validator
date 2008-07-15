class ProfileValidatorMigration < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string  :type
      t.integer :profileable_id
      t.string  :profileable_type
      t.string  :url
      t.text    :hcard
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
