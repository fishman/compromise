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

    def free_slots(timeslots)
      new_slots = []
      if timeslots.size == 1
        timeslots[0].end..end_of_day
      else
        timeslots.each do |ts|
jjk
        end
      end
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
