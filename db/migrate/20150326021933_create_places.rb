class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :business
      t.text :area

      t.timestamps
    end
  end
end
