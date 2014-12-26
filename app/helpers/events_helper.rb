module EventsHelper
  def year_range 
    if @start_event
      start = [@start_event.happened_on.year-5, Event.order(:happened_on).first.happened_on.year].min
      finish = [@start_event.happened_on.year+5, Event.order(:happened_on).last.happened_on.year].max
      start..finish
    else
      []
    end
  end
  
  def format_date(y,m,d)
    "#{sprintf("%.4d", y)}-#{sprintf("%02d", m)}-#{sprintf("%02d", d)}"
  end
end
