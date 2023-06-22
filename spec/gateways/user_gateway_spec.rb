require 'rails_helper'

describe UserGateway do
  it 'can find by id' do
    user_db = User.create!(name: "Alice")

    user = UserGateway.find(user_db.id)
    
    expect(user[:name]).to eq("Alice")
  end

  it 'return nil if user not found' do
    user = UserGateway.find(99999)
    
    expect(user).to eq(nil)
  end
end