module Lottery

  require_relative("../../requiredmodules.rb")

  extend Discordrb::Commands::CommandContainer

  #The variables below load up when the bot is started so that they can store info outside of the command.

  #Entered users array
  lottousers = []

  #Whether the lottery has started. 0 = No, 1 = Yes
  started = 0

  #The user that started the lottery.
  startuser = ""

  command(:lotto, min_args: 1, max_args: 1, description: 'Start a lottery.', usage: '!lotto <start>/<enter>/<end>') do |event, arg|

    event.message.delete

    data = YAML::load_file(File.join(__dir__, "config/lottery-config.yml"))

    userauth = Required::Auth.new

    userauth.auth(data["adminroles"], event.server.roles, event.user)

    #If command argument is start and the lottery is not already started, start the lottery.
    if (arg == 'start') && (started == 0)

      #Variable showing lottery is started
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

    elsif (arg == 'kill') && (started == 1) && (adminuser == true)

      started = 0

      event.respond "#{event.user.mention} has killed this lottery"

    else

      event.respond "Invalid parameters."

    end

  end

end
