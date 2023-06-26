class SleepGateway
  def self.find_all_by_user_id(user_id)
    results = []

    Sleep.where(user_id: user_id).find_each do |sleep|
      results << {
        id: sleep.id,
        start_at: sleep.start_at,
        end_at: sleep.end_at
      }
    end

    results
  end
end