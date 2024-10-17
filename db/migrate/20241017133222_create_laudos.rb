class CreateLaudos < ActiveRecord::Migration[7.1]
  def change
    create_table :laudos, id: :uuid do |t|
      t.date :data
      t.string :crm
      t.text :texto
      t.binary :arquivo

      t.timestamps
    end
  end
end
