# frozen_string_literal: true

class FixJwtBlacklistTable < ActiveRecord::Migration[5.2]
  def change
    add_column :jwt_blacklist, :exp, :datetime, null: false
  end
end
