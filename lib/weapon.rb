# weapon.rb

class Weapon
  attr_reader :name

  def initialize(name, damage = nil)
    @name = name
    @damage = damage
  end
end

