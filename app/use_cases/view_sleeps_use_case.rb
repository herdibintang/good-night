require "interactor"

class ViewSleepsUseCase
  include Interactor

  def call
    sleeps = SleepGateway.find_all()

    user_ids = sleeps.map { |sleep| sleep[:user_id] }

    users = UserGateway.find_by_ids(user_ids)

    context.sleeps = sleeps.map { |sleep|
      user = users.find { |user| user[:id] == sleep[:user_id] }

      {
        id: sleep[:id],
        start_at: sleep[:start_at],
        end_at: sleep[:end_at],
        duration_in_second: sleep[:duration_in_second],
        user: {
          name: user[:name]
        }
      }
    }
  end
end