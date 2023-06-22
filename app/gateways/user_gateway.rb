class UserGateway
  def self.find(id)
    User.find_by(id: id)
  end

  def self.create(*args)
    User.create(args)[0]
  end

  def self.find_followings_by_user_id(id)
    User.find(id).followings
  end
end