class ChangeDurationName < ActiveRecord::Migration[7.0]
  def change
    rename_column :sleeps, :duration, :duration_in_second
  end
end
