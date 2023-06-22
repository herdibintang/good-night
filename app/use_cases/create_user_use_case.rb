require "interactor"

class CreateUserUseCase
  include Interactor

  def call
    context.user = User.create!(name: context.name)
  end
end