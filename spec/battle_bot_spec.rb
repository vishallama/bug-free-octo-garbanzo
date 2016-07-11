require 'spec_helper'
require 'battle_bot'
require 'weapon'

describe BattleBot do

  let(:bot) { BattleBot.new("C-3PO") }
  let(:enemy) { BattleBot.new("R2-D2") }

  let(:light_saber){ Weapon.new("LightSaber") }
  let(:photo_torpedo){ Weapon.new("PhotonTorpedo", 20) }
  let(:death_star){ Weapon.new("DeathStart", 30) }


  before do
    BattleBot.class_variable_set(:@@count, 0)
  end


  # ------------------------------------
  # #initialize
  # ------------------------------------

  describe '#initialize' do

    it 'accepts a string name for the bot as the first parameter' do
      expect { bot }.to_not raise_error
    end


    it 'raises an ArgumentError when the no name is passed' do
      expect { BattleBot.new }.to raise_error(ArgumentError)
    end


    it "sets the name attribute when passed correctly" do
      expect(bot.name).to eq("C-3PO")
    end


    it "sets health to a default value of 100" do
      expect(bot.health).to eq(100)
    end


    it 'sets enemies to an empty array' do
      expect(bot.enemies).to eq([])
    end


    it "initializes with weapon set to nil" do
      expect(bot.weapon).to eq(nil)
    end


    it "is not dead" do
      expect(bot.dead?).to eq(false)
    end


    it "does not start with a weapon" do
      expect(bot.has_weapon?).to eq(false)
    end
  end


  # ------------------------------------
  # #name
  # ------------------------------------


  describe '#name' do

    it "raises NoMethodError when trying to assign a new value" do
      expect { bot.name = "Droid" }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #health
  # ------------------------------------


  describe '#health' do

    it "raises NoMethodError when trying to assign a new value" do
      expect { bot.health = 500 }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #enemies
  # ------------------------------------


  describe '#enemies' do

    it "raises NoMethodError when trying to assign a new value" do
      expect { bot.enemies = [] }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #weapon
  # ------------------------------------  


  describe '#weapon' do

    it "raises NoMethodError when trying to assign a new value" do
      expect { bot.weapon = light_saber }.to raise_error(NoMethodError)
    end
  end


  # ------------------------------------
  # #has_weapon?
  # ------------------------------------


  describe '#has_weapon?' do

    it 'returns true when the bot has a weapon' do
      bot.pick_up(light_saber)
      expect(bot.has_weapon?).to eq(true)
    end


    it 'returns false when the bot does not have a weapon' do
      expect(bot.has_weapon?).to eq(false)
    end
  end


  # ------------------------------------
  # #dead?
  # ------------------------------------  


  describe '#dead?' do

    it "returns true when the bot's health is 0" do
      bot.take_damage(1000)
      expect(bot.dead?).to eq(true)
    end


    it "returns false when the bot's health is greater than 0" do
      expect(bot.dead?).to eq(false)
    end
  end


  # ------------------------------------
  # #pick_up
  # ------------------------------------


  describe '#pick_up' do

    it 'accepts a weapon as a parameter' do
      expect { bot.pick_up(photo_torpedo) }.to_not raise_error
    end


    it 'raises an ArgumentError if the parameter is not a Weapon' do
      expect { bot.pick_up("Not a weapon!") }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError if the weapon has been picked up by any bot' do
      enemy.pick_up(photo_torpedo)
      expect { bot.pick_up(photo_torpedo) }.to raise_error(ArgumentError)
    end


    context 'the bot already has a weapon' do

      before do
        bot.pick_up(photo_torpedo)
      end


      it "does not change the weapon that the bot already has" do
        bot.pick_up(death_star)
        expect(bot.weapon).to eq(photo_torpedo)
      end


      it "does not set the weapon's bot attribute to the bot" do
        bot.pick_up(death_star)
        expect(death_star.bot).to_not eq(bot)
      end


      it 'does not call weapon#bot=' do
        expect(death_star).to_not receive(:bot=)
        bot.pick_up(death_star)
      end


      it 'returns nil' do
        expect(bot.pick_up(death_star)).to be_nil
      end
    end


    context 'the bot does not have a weapon' do

      it "sets the bot's weapon to the weapon being picked up" do
        bot.pick_up(death_star)
        expect(bot.weapon).to eq(death_star)
      end


      it "sets the weapon's bot attribute to the bot" do
        bot.pick_up(death_star)
        expect(death_star.bot).to eq(bot)
      end


      it 'calls weapon#bot= and passes it the bot doing the pick up' do
        expect(death_star).to receive(:bot=).with(bot)
        bot.pick_up(death_star)
      end


      it 'returns the weapon that was picked up' do
        expect(bot.pick_up(death_star)).to eq(death_star)
      end
    end
  end


  # ------------------------------------
  # #drop_weapon
  # ------------------------------------


  describe '#drop_weapon' do

    before do
      bot.pick_up(light_saber)
      bot.drop_weapon
    end


    it 'sets bot#weapon to nil' do
      expect(bot.weapon).to be_nil
    end


    it 'sets weapon#bot to nil' do
      expect(light_saber.bot).to be_nil
    end
  end


  # ------------------------------------
  # #take_damage
  # ------------------------------------


  describe '#take_damage' do

    it 'accepts a Fixnum parameter of the damage amount' do
      expect { bot.take_damage(1) }.to_not raise_error
    end


    it 'raises an error when the parameter is not a Fixnum' do
      expect { bot.take_damage("Virus") }.to raise_error(ArgumentError)
    end


    it "descreases the bot's health by the damage amount" do
      expect { bot.take_damage(10) }.to change(bot, :health).by(-10)
    end


    it "does not allow health to drop below a value of 0" do
      bot.take_damage(bot.health + 1000)
      expect(bot.health).to eq(0)
    end


    it 'returns the current health value' do
      expect(bot.take_damage(10)).to eq(bot.health)
    end
  end


  # ------------------------------------
  # #heal
  # ------------------------------------


  describe '#heal' do

    context 'the bot is damaged but not dead' do

      before do
        bot.take_damage(50)
      end


      it 'increases health by 10' do
        expect { bot.heal }.to change(bot, :health).by(10)
      end


      it 'does not allow health to be above 100' do
        10.times { bot.heal }
        expect(bot.health).to eq(100)
      end


      it 'returns the current health value' do
        expect(bot.heal).to eq(bot.health)
      end
    end

    context 'the bot is dead' do

      it 'does not change the value of health' do
        bot.take_damage(1000)
        expect { bot.heal }.to change(bot, :health).by(0)
      end
    end
  end


  # ------------------------------------
  # #attack
  # ------------------------------------


  describe '#attack' do

    before do
      bot.pick_up(death_star)
    end


    it 'raises an ArgumentError if the enemy is not a BattleBot' do
      expect { bot.attack("Puppy") }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError if attempting to self attack' do
      expect { bot.attack(bot) }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError if the bot has no weapon to attack with' do
      bot.drop_weapon
      expect { bot.attack(enemy) }.to raise_error(ArgumentError)
    end


    it 'accepts an enemy bot as a parameter' do
      bot.pick_up(light_saber)
      expect { bot.attack(enemy) }.to_not raise_error
    end



    context 'the bot can attack' do

      it 'calls enemy#receive_attack_from passing the bot who attacked' do
        expect(enemy).to receive(:receive_attack_from).with(bot)
        bot.attack(enemy)
      end
    end
  end


  # ------------------------------------
  # #receive_attack_from
  # ------------------------------------


  describe '#receive_attack_from' do

    before do
      enemy.pick_up(death_star)
    end


    it 'accepts an enemy bot as a parameter' do
      expect { bot.receive_attack_from(enemy) }.to_not raise_error
    end


    it 'raises an ArgumentError if the enemy is not a BattleBot' do
      expect { bot.receive_attack_from("Puppy") }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError if attempting to receive self attack' do
      expect { bot.receive_attack_from(bot) }.to raise_error(ArgumentError)
    end


    it 'raises an ArgumentError if the enemy has no weapon to attack with' do
      enemy.drop_weapon
      expect { bot.receive_attack_from(enemy) }.to raise_error(ArgumentError)
    end


    it 'calls #take_damage on the bot passing the enemy weapon damage amount' do
      expect(bot).to receive(:take_damage).with(enemy.weapon.damage)
      bot.receive_attack_from(enemy)
    end


    it 'adds the enemy to enemies array of the bot receiving the attack' do
      bot.receive_attack_from(enemy)
      expect(bot.enemies.include?(enemy)).to eq(true)
    end


    it 'does not add the enemy to the enemies array if the enemy is already in the array' do
      5.times { bot.receive_attack_from(enemy) }
      expect(bot.enemies.length).to eq(1)
    end


    it 'calls #defend_against on the bot receiving the attack passing the enemy as a parameter' do
      expect(bot).to receive(:defend_against).with(enemy)
      bot.receive_attack_from(enemy)
    end

    context 'the two bots fight until one is dead' do

      it 'does not raise a stack overflow error when calling #defend_against' do
        bot.pick_up(light_saber)
        expect { bot.receive_attack_from(enemy) }.to_not raise_error
      end
    end
  end


  # ------------------------------------
  # #defend_against
  # ------------------------------------


  describe '#defend_against' do

    it 'accepts an enemy bot as a parameter' do
      expect { bot.defend_against(enemy) }.to_not raise_error
    end


    it 'calls #dead?' do
      expect(bot).to receive(:dead?)
      bot.defend_against(enemy)
    end


    it 'calls #has_weapon?' do
      expect(bot).to receive(:has_weapon?)
      bot.defend_against(enemy)
    end

    context 'the bot is alive and has a weapon' do

      before do
        bot.pick_up(light_saber)
      end


      it 'calls #attack on the defending bot passing the enemy as a parameter' do
        expect(bot).to receive(:attack).with(enemy)
        bot.defend_against(enemy)
      end
    end


    context 'the bot is dead' do

      before do
        bot.take_damage(1000)
      end


      it 'does not call #attack' do
        expect(bot).to_not receive(:attack)
      end
    end


    context 'the bot is weaponless' do

      it 'does not call #attack' do
        expect(bot).to_not receive(:attack)
      end
    end
  end


  # ------------------------------------
  # #has_weapon?
  # ------------------------------------


  describe '#has_weapon?' do

    it 'returns true when the bot has a weapon' do
      bot.pick_up(light_saber)
      expect(bot.has_weapon?).to eq(true)
    end


    it 'returns false when the bot does not have a weapon' do
      expect(bot.has_weapon?).to eq(false)
    end
  end


  # ------------------------------------
  # #dead?
  # ------------------------------------  


  describe '#dead?' do

    it "returns true when the bot's health is 0" do
      bot.take_damage(1000)
      expect(bot.dead?).to eq(true)
    end


    it "returns false when the bot's health is greater than 0" do
      expect(bot.dead?).to eq(false)
    end
  end


  # ------------------------------------
  # BattleBot#count
  # ------------------------------------  


  describe 'BattleBot#count' do

    let(:bots) { [ bot, enemy ] }

    before do
      bots
    end


    it 'is incremented when a new bot is instantiated' do
      expect { BattleBot.new("RuboCop") }.to change(BattleBot, :count).by(1)
    end


    it 'is decremented when a bot is killed' do
      expect { bot.take_damage(1000) }.to change(BattleBot, :count).by(-1)
    end
  end


end

