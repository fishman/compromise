class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def sample_req

    w_api = Wunderground.new("ca4fc52f5d924640")
    planner = w_api.forecast10day_for("Germany/Berlin")
    planner["forecast"]["simpleforecast"]["forecastday"][6]
    # check rain 

    locks = Event.invert_timeslot(timeslot)
    locks.each do |ts|
      TimeLock.create(starts_at: ts.begin, ends_at: ts.end)
    end

    Event.upcoming_week.each do |d|
      appointments = Appointment.for_day(day).load.to_a
      timelocks =  TimeLock.for_day(day).load.to_a
      all_events = Event.for_day(day).load.to_a
    end

    timeslots = []
    all_events.each do |event|
      timeslots << (event.starts_at)..(event.ends_at)
    end

    timeslots = Event.merge_ranges(timeslots)

    # returns new timeslots
    Event.free_slots(timeslots)
  end
end
