require 'rails_helper'

describe UserGateway do
  it 'can find by id' do
    user_db = User.create!(name: "Alice")

    user = UserGateway.find(user_db.id)
    
    expect(user[:name]).to eq("Alice")
  end

  it 'can find by ids' do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "Bob")

    users = UserGateway.find_by_ids([user1.id, user2.id])
    
    expect(users[0][:name]).to eq("Alice")
    expect(users[1][:name]).to eq("Bob")
  end

  it 'return nil if user not found' do
    user = UserGateway.find(99999)
    
    expect(user).to eq(nil)
  end

  it 'return nil if user not found' do
    user = UserGateway.create(name: "Alice")
    
    expect(user[:name]).to eq("Alice")
  end
end