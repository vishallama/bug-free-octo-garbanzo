# battle_bot.rb
require 'weapon'

class BattleBot
  @@weapons_picked_up = []

  attr_reader :name, :health, :enemies, :weapon

  def initialize(name = nil)
    raise ArgumentError if name.nil?
    @name = name
    @health = 100
    @enemies = []
    @weapon = nil
    @has_weapon = false
  end

  def dead?
    health <= 0
  end

  def has_weapon?
    @has_weapon
  end

  def pick_up(new_weapon)
    raise ArgumentError if !new_weapon.instance_of?(Weapon)
    raise ArgumentError if @@weapons_picked_up.include?(new_weapon)

    @weapon = new_weapon
    @has_weapon = true
    @@weapons_picked_up << new
  end

  def take_damage(damage)
    return ArgumentError if !damage.instance_of?(Fixnum)

    @health = (@health - damage) < 0 ? 0 : (health - damage)
  end

  def heal
    @health = (@health + 10) > 100 ? 100 : (health + 10)
  end

end
