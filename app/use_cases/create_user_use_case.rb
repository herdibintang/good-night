require "interactor"

class CreateUserUseCase
  include Interactor

  def call
    context.user = UserGateway.create(name: context.name)
  end
end