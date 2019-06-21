class CreatePlays < ActiveRecord::Migration[5.2]
  def change
    create_table :plays do |t|
      t.references :player, foreign_key: true
      t.references :match, foreign_key: true
      t.float :distance, default: 0.0
      t.integer :total_pass, default: 0
      t.integer :success_pass, default: 0

      t.timestamps
    end
  end
end
