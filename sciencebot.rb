require 'rrobots'

# SCIENCE!
class Sciencebot
  include Robot

  # FIXME: Firing should not be directly linked to the radar or it's not much
  # better than the previous algorithm. Instead, use fast radar scans to
  # keep the enemy in sight and aim narrowly near the middle of the scans.

  # FIXME: Moving should be not a circular dodge but rather a serpentine
  # pattern backwards from the location of the enemy.

  # FIXME: Firing cone size should be dependent on the distance from the enemy?

  # FIXME: Calculated enemy location still has problems with 360 degrees
  # wrapping.

  def initialize
    @tick_turns = { body: 0, gun: 0, radar: 0 }
    @radar_scan_step_size = 7
    @radar_sweep_step_size = 40
    # @search_counter = 0
    # @maximum_enemy_missing_time = 100
    @enemy_sightings = []
    @gun_random_component = 10
    @gun_correction_speed = 5
    @spray_range = (-@gun_random_component..@gun_random_component).to_a
  end

  def tick(events)
    combat_mode_or_sweep(events)
    science!
    execute_turns
  end

  def execute_turns
    turn @tick_turns[:body]
    turn_gun @tick_turns[:gun]
    turn_radar @tick_turns[:radar]
    @tick_turns = { body: 0, gun: 0, radar: 0 }
  end

  def combat_mode_or_sweep(events)
    if @combat_mode ||= robot_detected?(events)
      approximate_enemy_location(events)
      scanning_pass(events)
      fire_at_area
      dodge
    else
      radar_sweep
      dodge
    end
  end

  def approximate_enemy_location(events)
    @enemy_sightings << radar_heading if robot_detected?(events)
    @enemy_sightings.shift if @enemy_sightings.size > @gun_correction_speed
    @enemy_location = @enemy_sightings.inject(:+).to_f / @enemy_sightings.size
  end

  def scanning_pass(events)
    @scan_direction ||= 'negative'
    if target_lost(events)
      toggle_scan_direction
    else
      continue_scan(events)
    end
  end

  def target_lost(events)
    true if @scan_status == 'found' && no_robot_detected?(events)
  end

  def toggle_scan_direction
    puts "toggle activated"
    if @scan_direction == 'positive'
      @scan_direction = 'negative'
    else
      @scan_direction = 'positive'
    end
    @scan_status = 'searching'
  end

  def continue_scan(events)
    @scan_status = 'found' if robot_detected?(events)
    if @scan_direction == 'positive'
      @tick_turns[:radar] += @radar_scan_step_size
      puts "scanning up"
    else
      @tick_turns[:radar] -= @radar_scan_step_size
      puts "scanning down"
    end
  end

  def robot_detected?(events)
    events['robot_scanned'].any?
  end

  def no_robot_detected?(events)
    events['robot_scanned'].empty?
  end

  def radar_sweep
    @tick_turns[:radar] += @radar_sweep_step_size
  end

  def fire_at_area
    difference = gun_heading - @enemy_location
    gun_turn_degrees = @spray_range.sample - difference
    @tick_turns[:gun] += gun_turn_degrees
    @tick_turns[:radar] -= gun_turn_degrees
    fire 0.1
  end

  def science!
    say('Burn them with SCIENCE!')
  end

  def serpentine

  end

  # def enemy_eliminated?
  #   if @search_counter > @maximum_enemy_missing_time
  #     @search_counter = 0
  #     enable_search_mode
  #   else
  #     @search_counter += 1 if events['robot_scanned'].empty?
  #   end
  # end

  # def enable_search_mode
  #   @combat_mode = nil
  #   @enemy_location = nil
  #   @detected_values = []
  # end

  # def search_mode
  #   fire 0.1
  #   turn_gun 1
  # end

  # def radar_sweep
  #   difference = radar_heading - @enemy_location
  #   turn_radar(@radar_range.sample - difference)
  # end

  # def cache_gun_heading
  #   @enemy_location ||= gun_heading
  # end


  # def store_enemy_location_probability(events)
  #   @detected_values.push(radar_heading) if events['robot_scanned'].any?
  #   @detected_values.shift if @detected_values.size > 20
  # end

  def dodge
    accelerate 1
    @tick_turns[:body] += 5
    @tick_turns[:gun] -= 5
  end
end
