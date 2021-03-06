# Sciencebot

These are the bots developed over a few hours in my Ruby on Rails Development
Accelerator at Code Fellows. Sciencebot was the project I worked on with
Mike Chen and [Reed Nelson-Saunders](https://github.com/reedns).
I then spent some extra time afterwards
improving the algorithms. The bot is meant to counteract evasive dodging by
locating an enemy tank and shooting in a random pattern around that location.
It proves to be a solid algorithm, but only works well at long range.

Should I ever come back to this, future improvements would include improving
the firing cone depending on range and a movement algorithm which sends the
robot in the opposite direction of anything it detects, putting the chances most
in its favor.

Basic Repo for RoboTank Showdown!
==================================
    # Fork this repo, so you can submit your tank via PR

    # Clone your fork. Then install the project dependencies
    $ bundle install

    # Run the sample robots
    $ bundle exec rrobots Killa Duck

    # Now go make your own!

Possible Install Issues
=======================

If you have a problem installing the GOSU library, there's a helpful
error message which links to this:

https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux

You may need to install a few packages

### Useful resources: ###

http://rubydoc.info/gems/rrobots/0.0.1/frames

https://github.com/ralreegorganon/rrobots

http://rubyforge.org/forum/?group_id=1109

### Some methods...: ###
    battlefield_height  #the height of the battlefield
    battlefield_width   #the width of the battlefield
    energy              #your remaining energy (if this drops below 0 you are dead)
    gun_heading         #the heading of your gun, 0 pointing east, 90 pointing
                        #north, 180 pointing west, 270 pointing south
    gun_heat            #your gun heat, if this is above 0 you can't shoot
    heading             #your robots heading, 0 pointing east, 90 pointing north,
                        #180 pointing west, 270 pointing south
    size                #your robots radius, if x <= size you hit the left wall
    radar_heading       #the heading of your radar, 0 pointing east,
                        #90 pointing north, 180 pointing west, 270 pointing south
    time                #ticks since match start
    speed               #your speed (-8/8)
    x                   #your x coordinate, 0...battlefield_width
    y                   #your y coordinate, 0...battlefield_height
    accelerate(param)   #accelerate (max speed is 8, max accelerate is 1/-1,
                        #negative speed means moving backwards)
    stop                #accelerates negative if moving forward (and vice versa),
                        #may take 8 ticks to stop (and you have to call it every tick)
    fire(power)         #fires a bullet in the direction of your gun,
                        #power is 0.1 - 3, this power will heat your gun
    turn(degrees)       #turns the robot (and the gun and the radar),
                        #max 10 degrees per tick
    turn_gun(degrees)   #turns the gun (and the radar), max 30 degrees per tick
    turn_radar(degrees) #turns the radar, max 60 degrees per tick
    dead                #true if you are dead
    say(msg)            #shows msg above the robot on screen
    broadcast(msg)      #broadcasts msg to all bots (they receive 'broadcasts'
                        #events with the msg and rough direction)
