require 'spec_helper'
require 'weapon'
require 'battle_bot'

describe Weapon do


  let(:weapon) { Weapon.new("FooWeapon") }
  let(:bot) { BattleBot.new("BarBot") }


  # ------------------------------------
  # #initialize
  # ------------------------------------


  describe '#initialize' do

    it 'accepts a string name of the weapon as the first parameter' do
      expect { weapon }.to_not raise_error
    end


    it "sets the name attribute when passed correctly" do
      expect(weapon.name).to eq("FooWeapon")
    end


    it 'raises an ArgumentError when no name is passed' do
      expect { Weapon.new }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError when name is not a string' do
      expect { Weapon.new([]) }.to raise_error(ArgumentError)
    end


    it "optionally accepts an integer value for damage as the second parameter" do
      expect(Weapon.new('PhotonTorpedo', 20).damage).to eq(20)
    end


    it 'raises an ArgumentError when damage is not a Fixnum' do
      expect { Weapon.new('DeathStar', {}) }.to raise_error(ArgumentError)
    end

    
  end


  # ------------------------------------
  # #name
  # ------------------------------------


  describe '#name' do

    it 'raises NoMethodError when trying to assign a new value' do
      expect { weapon.name = 'Boom!' }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #damage
  # ------------------------------------


  describe '#damage' do

    it 'raises NoMethodError when trying to assign a new value' do
      expect { weapon.damage = 1234 }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #bot
  # ------------------------------------


  describe '#bot' do

    it 'does not raise an error when reading the bot' do
      expect { weapon.bot }.to_not raise_error
    end


    it 'defaults to nil' do
      expect(weapon.bot).to be_nil
    end


    it 'raises an ArgumentError when the value is not a BattleBot' do
      expect { weapon.bot = "I am NOT a robot!" }.to raise_error(ArgumentError)
    end

    
    it 'does not raise an ArgumentError when passed a BattleBot' do
      expect { weapon.bot = bot }.to_not raise_error
    end


    it 'does not raise an ArgumentError when passed nil' do
      expect { weapon.bot = nil }.to_not raise_error
    end
  end


  # ------------------------------------
  # #picked_up?
  # ------------------------------------


  describe '#picked_up?' do

    it 'returns true if the weapon has been picked up by a bot' do
      bot.pick_up(weapon)
      expect(weapon.picked_up?).to eq(true)
    end


    it 'returns false if the weapon has not been picked up by a bot' do
      expect(weapon.picked_up?).to eq(false)
    end
  end


end

