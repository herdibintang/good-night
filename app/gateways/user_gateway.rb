class UserGateway
  def self.find(id)
    User.find_by(id: id)
  end

  def self.create(*args)
    User.create(args)[0]
  end
end