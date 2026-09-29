class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.date :date, null: false
      t.string :title, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.text :detail, null: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
