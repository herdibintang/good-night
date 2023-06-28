require "interactor"

class ViewSleepsUseCase
  include Interactor

  def call
    sleeps = Sleep.includes(:user).order(created_at: :desc)

    context.sleeps = sleeps.map { |sleep|
      {
        id: sleep.id,
        start_at: sleep.start_at,
        end_at: sleep.end_at,
        duration_in_second: sleep.duration_in_second,
        user: {
          name: sleep.user.name
        }
      }
    }
  end
end