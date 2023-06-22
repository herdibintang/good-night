require "interactor"

class ViewUsersUseCase
  include Interactor

  def call
    context.user = User.create!(name: context.name)
  end
end