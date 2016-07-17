# battle_bot.rb
require 'weapon'

class BattleBot
  @@weapons_picked_up = []
  @@count = 0

  attr_reader :name, :health, :enemies, :weapon

  def initialize(name = nil)
    raise ArgumentError if name.nil?
    @name = name
    @health = 100
    @enemies = []
    @weapon = nil
    @has_weapon = false
    @@count += 1
  end

  def dead?
    health == 0
  end

  def has_weapon?
    @has_weapon
  end

  def attack(other)
    raise ArgumentError if !other.instance_of? BattleBot 
    raise ArgumentError if other == self
    raise ArgumentError if !has_weapon?

    other.receive_attack_from(self)
  end

  def receive_attack_from(other)
    raise ArgumentError if !other.instance_of? BattleBot 
    raise ArgumentError if other == self
    raise ArgumentError if !other.has_weapon?

    take_damage(other.weapon.damage)
    enemies << other if !enemies.include? other

    defend_against(other)
  end

  def defend_against(other)
    if !dead? && has_weapon?
      attack(other)
    end
  end

  def pick_up(new_weapon)
    raise ArgumentError if !new_weapon.instance_of?(Weapon)
    raise ArgumentError if @@weapons_picked_up.include?(new_weapon)

    if weapon.nil?
      @weapon = new_weapon
      @has_weapon = true
      @@weapons_picked_up << new_weapon 
      new_weapon.bot = self
      new_weapon
    else
      nil
    end
  end

  def drop_weapon
    @weapon.bot = nil
    @weapon = nil
    @has_weapon = false
  end

  def take_damage(damage)
    raise ArgumentError if !damage.instance_of?(Fixnum)

    @health = (@health - damage) < 0 ? 0 : (health - damage)
    @@count -= 1 if dead?
    health
  end

  def heal
    if health == 0
      return
    else
      @health = (health + 10) > 100 ? 100 : (health + 10)
    end
  end

  def self.count
    @@count
  end

end
