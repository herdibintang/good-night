class UserGateway
  def self.find(id)
    User.find_by(id: id)
  end

  def self.find_by_ids(id)
    User.where(id: id)
  end

  def self.create(*args)
    User.create(args)[0]
  end

  def self.find_followings_by_user_id(id)
    User.find(id).followings
  end

  def self.refresh_followings(user_entity)
    Follow.where(from_user_id: user_entity.id).destroy_all

    user_entity.followings.each do |following|
      Follow.create!(from_user_id: user_entity.id, to_user_id: following.id)
    end
  end
end