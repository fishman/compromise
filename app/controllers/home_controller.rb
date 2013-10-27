class HomeController < ApplicationController
  def index
    @users = User.all
    debug_method 2
    debug_method 0
  end

  def sample_req
    debug_method 2
    debug_method 0
  end


  def debug_method(index = 2)
    Event.all.each do |event|
      event.destroy
    end

    Event.upcoming_week.each_with_index do |d, i|
      if i == index
        TimeLock.create(starts_at: d.beginning_of_day, ends_at: d.end_of_day-2.hours)
      else
        TimeLock.create(starts_at: d.beginning_of_day, ends_at: d.end_of_day)
      end
    end

    # locks = Event.invert_timeslot(timeslot)
    # locks.each do |ts|
    #   TimeLock.create(starts_at: ts.begin, ends_at: ts.end)
    # end

    # Event.create(

    Event.upcoming_week.each do |day|
      appointments = Appointment.for_day(day).to_a
      timelocks =  TimeLock.for_day(day).to_a
      all_events = Event.for_day(day).to_a
      logger.info all_events
    end
      all_events = Event.all.to_a

    timeslots = []
    all_events.each do |event|
      timeslots << (event.starts_at..event.ends_at)
    end
    logger.info "original #{timeslots}"

    timeslots = Event.merge_ranges(timeslots)
    logger.info "reduced timeslots #{timeslots}"

    # returns new timeslots
    timeslots = Event.free_slots(timeslots)
    logger.info "rainy? #{Event.rainy_weather_for_slot(timeslots[0])} timeslot #{timeslots}"
  end
end
