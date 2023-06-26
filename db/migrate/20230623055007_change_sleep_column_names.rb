class ChangeSleepColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :sleeps, :clock_in, :start_at
    rename_column :sleeps, :clock_out, :end_at
  end
end
