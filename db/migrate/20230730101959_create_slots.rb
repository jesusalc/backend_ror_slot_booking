# frozen_string_literal: true

# migration for the slots and opens
class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.datetime :start
      t.datetime :end

      t.timestamps
    end

    create_table :opens do |t|
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
