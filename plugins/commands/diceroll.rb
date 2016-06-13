module Diceroller

  extend Discordrb::Commands::CommandContainer
  
  coin = ['You flipped heads', 'You flipped tails']
  fudge = ['+', '-', 'blank']

  command(:roll, description: 'Rolls a Die', usage: 'roll <text>') do |event, text, symbol, mod|

    user = event.user.username

    #puts text.length

    if text != nil
    
      info = text.split("d") 

      #Get dice integers from input
      min = info[0].to_i
      max = info[1].to_i   

      #Get max possible roll
      max = min*max

      roll = rand(min..max)

      mod = mod.to_i

        if (mod > 0) || (mod < 0)    

          if symbol == "+"

            total = roll + mod

            event.respond "#{user} rolled a #{roll} #{symbol} #{mod} for a total of #{total}"

          elsif symbol == "-"

            total = roll - mod
 
            event.respond "#{user} rolled a #{roll} #{symbol} #{mod} for a total of #{total}"

          end

        else

          event.respond "#{user} rolled a #{roll}"

        end

    else

      roll = rand(1..6) 

      event.respond "#{user} rolled a #{roll}"

    end

  end

  command(:coin, description: 'Flip a coin') do |event|
    event.respond coin.sample 
  end

  command(:fudge, description: 'Roll a fudge die') do |event|
    event.respond "You rolled #{fudge.sample}, #{fudge.sample}, #{fudge.sample}, #{fudge.sample}"
  end

end
