class UserGateway
  def self.find(id)
    User.find_by(id: id)
  end
end