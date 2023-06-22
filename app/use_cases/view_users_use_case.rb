require "interactor"

class ViewUsersUseCase
  include Interactor

  def call
    context.users = User.all
  end
end