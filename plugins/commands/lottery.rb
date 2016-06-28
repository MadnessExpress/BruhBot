module Lottery

  extend Discordrb::Commands::CommandContainer

  #The variables below load up when the bot is started so that they can store info outside of the command.

  #Entered users array
  lottousers = []

  #Whether the lottery has started. 0 = No, 1 = Yes
  started = 0

  #The user that started the lottery.
  startuser = ''

  userrole = ["Admin", "Bot Commander"]

  command(:lotto, min_args: 1, max_args: 1, description: 'Start a lottery.', usage: '!lotto <start>/<enter>/<end>') do |event, arg|

    event.message.delete

    #userroleid = []
    
    #userrole.each do |role|

      #userroleid << event.server.roles.find { |r| r.name == role }

    #end

    #test = false

    #userroleid.each do |role|

      #if (event.user.role?(role) == true)

        #test = true

      #else

        #puts "False"

      #end

    #end

    #puts test

    #If command argument is start and the lottery is not already started, start the lottery.
    if (arg == 'start') && (started == 0)

      started = 1

      #Get user mention for message
      user = event.user.mention

      #Set user that started the lottery
      startuser = event.user.id

      event.respond "#{user} has started a lottery!"

    #If command argument is start and the lottery is already started
    elsif (arg == 'start') && (started == 1)

      event.respond "There is already a lottery in progress."

    elsif (arg == 'enter') && (started == 1)

      user = event.user.mention

      checkuser = lottousers.include? user

      if checkuser == true

        event.respond "You have already entered the lottery."

      elsif checkuser == false

        lottousers << user

        event.respond "#{user} has entered the lottery."

      end

    elsif (arg == 'end') && (started == 1) && (startuser == event.user.id)

      started = 0

      winner = lottousers.sample

      lottousers = []

      startuser = ''

      event.respond "The lottery has ended and #{winner} is the winner!"

    #elsif (arg == 'kill') && (started == 1) && 

    else

      event.respond "Invalid parameters."

    end

  end

end
