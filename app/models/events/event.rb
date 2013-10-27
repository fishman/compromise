class Event < ActiveRecord::Base
  class << self
    def for_day(day)
      where('starts_at >= :lo and ends_at < :up',
            :lo => day.beginning_of_day,
            :up => (day+1.day).beginning_of_day
           )
    end


    def upcoming_week
      (Date.tomorrow..(Date.tomorrow+7.days))
    end

    def slot_length(timeslot)
      (timeslot.end - timeslot.begin).minutes.round
    end

    def free_slots(timeslots)
      new_slots = []
      if timeslots.size == 1
        slot = timeslots[0].end..end_of_day
        new_slots << slot if slot_length(slot) > 0
      else
        timeslots.each_with_index do |ts, i|
          if i == 0
            # do something with the first item
          end

          last_slot = timeslots[i-1]
          current_slot = timeslots[i]
          slot = last_slot.end..current_slot.begin 
          new_slots << slot if slot_length(slot) > 0
          # common stuff
        end
      end
      new_slots
    end

    def rainy_weather_for_slot(slot)
      w_api = Wunderground.new("ca4fc52f5d924640")
      planner = w_api.forecast10day_for("Germany/Berlin")

      index = (slot.begin).day - Time.now.day
      forecast = planner["forecast"]["simpleforecast"]["forecastday"][index]

      forecast["conditions"].downcase.include? "rain"
    end

    # takes a timeslot where you do have time and 
    # creates blocking events for the rest of the day when
    # you don't
    def invert_timeslot(timerange)
      [timerange.beginning_of_day..timerange.begin,
       timerange.end..timerange.end_of_day]
    end

    def merge_ranges(ranges)
      ranges = ranges.sort_by {|r| r.first }
      *outages = ranges.shift
      ranges.each do |r|
        lastr = outages[-1]
        if lastr.last >= r.first - 1
          outages[-1] = lastr.first..[r.last, lastr.last].max
        else
          outages.push(r)
        end
      end
      outages
    end
  end
end
