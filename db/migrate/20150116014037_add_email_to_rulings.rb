class AddEmailToRulings < ActiveRecord::Migration
  def change
    add_column :rulings, :email, :string
  end
end
