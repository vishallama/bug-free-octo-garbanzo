# weapon.rb

class Weapon
  attr_reader :name, :damage
  attr_accessor :bot

  def initialize(name, damage = 0)
    raise ArgumentError if !name.instance_of? String
    raise ArgumentError if !damage.instance_of? Fixnum
    @name = name
    @damage = damage
    @bot = nil
    @picked_up = false
  end

  def bot=(some_bot)
    raise ArgumentError unless some_bot.nil? || some_bot.instance_of?(BattleBot)
    @bot = some_bot
    @picked_up = true
  end

  def picked_up?
    @picked_up
  end
end

