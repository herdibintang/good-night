require 'rails_helper'

RSpec.describe "DELETE /users/:id", type: :request do
  it "can delete user" do
    user = User.create!(name: "Alice")

    delete "/users/#{user.id}", as: :json

    user2 = User.find_by(id: user.id)
    expect(user2).to eq(nil)
  end
end
