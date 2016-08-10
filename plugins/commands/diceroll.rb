@export = ["Diceroller"]
module Diceroller

  extend Discordrb::Commands::CommandContainer

  command(:roll, description: "Rolls a die or dice", usage: "roll <text>") do |event, dice, symbol, mod|

    #Load config file.
    data = YAML::load_file(File.join(__dir__, 'config/diceroll.yml'))

    #Do this if the argument after roll is fudge.
    if (dice == "fudge")

      #Output a roll of fudge dice from the array in the config.
      event.respond "You rolled the following fudge dice: (:game_die:#{data["fudge"].sample}, :game_die:#{data["fudge"].sample}, :game_die:#{data["fudge"].sample}, :game_die:#{data["fudge"].sample})"
       
    #Do this if there is an argument after roll. EX: roll 2d6
    elsif (dice != nil)
    
      #Remove the d from between the number of dice and the number of sides of the dice.
      info = dice.split("d") 

      #Assign a random number to roll based on the number of dice and the number of sides of the dice.
      #Max roll = number of dice * number of sides on the dice.
      roll = rand(info[0].to_i..(info[0].to_i * info[1].to_i))

      #Do this if the symbol is a plus sign.
      if symbol == "+"

        #Output the user, what they rolled plus their modifer, and show their total. 
        event.respond "#{event.user.username} rolled a (:game_die:#{roll} #{symbol} #{mod.to_i}) for a total of :game_die:#{roll + mod.to_i}"

      #Do this if the symbol is a minus sign.
      elsif symbol == "-"

        #Output the user, what they rolled minus their modifer, and show their total.
        event.respond "#{event.user.username} rolled a (:game_die:#{roll} #{symbol} #{mod.to_i}) for a total of :game_die:#{roll + mod.to_i}"
      
      #Do this in all other situations.
      else

        #Output the user, and what they rolled.
        event.respond "#{event.user.username} rolled a #{roll}"

      #End if statement to check for symbols.
      end
    
    #Do this in all other situations. EX: The roll command is used with no arguments.
    else

      #Output the user, and what they rolled on a six sided die.
      event.respond "#{event.user.username} rolled a #{rand(1..6)}"

    #End the if statement to see what dice need to be rolled.
    end
  
  #End roll command
  end

  command(:coin, description: "Flip a coin") do |event|

    #Output an option from the coin array in the config.
    event.respond data["coin"].sample 

  #End coin flip command
  end

#End diceroll module
end
