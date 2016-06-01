module Diceroller
  extend Discordrb::Commands::CommandContainer
  
  coin = ['You flipped heads', 'You flipped tails']
  fudge = ['+', '-', 'blank']

  command(:roll, min_args: 1, description: 'Rolls a Die', usage: 'roll <text>') do |event, text|
    info = text.split("d") 

    #event.respond text  

    a = info[0].to_i
    b = info[1].to_i   

    x = a*b 

    roll = rand(a..x)
    
    user = event.user.username

    #if user == 'Example'    

    #  event.respond 'You aren\'t allowed to roll'

    #else

      event.respond "#{user} rolled a #{roll}"

    #end

  end

  command(:coin, description: 'Flip a coin') do |event|
    event.respond coin.sample 
  end

  command(:fudge, description: 'Roll a fudge die') do |event|
    event.respond "You rolled #{fudge.sample}, #{fudge.sample}, #{fudge.sample}, #{fudge.sample}"
  end

end
