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

  def self.find_all()
    results = []
    
    Sleep.order(created_at: :desc).all.each do |sleep|
      results << {
        id: sleep.id,
        user_id: sleep.user_id,
        start_at: sleep.start_at,
        end_at: sleep.end_at,
        duration_in_second: sleep.duration_in_second
      }
    end

    results
  end
end