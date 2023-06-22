class SleepGateway
  def self.find_all_by_user_id(user_id)
    results = []

    Sleep.where(user_id: user_id).find_each do |sleep|
      results << {
        id: sleep.id,
        start_at: sleep.clock_in,
        end_at: sleep.clock_out
      }
    end

    results
  end
end