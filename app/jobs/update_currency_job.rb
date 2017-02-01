# The Job's job is to update today's currency value
# if it was changed during the day (source changed it)
class UpdateCurrencyJob < ApplicationJob
  queue_as :default

  def perform(curr)
    new_val = curr.fetch
    # indicate that the data ma be stale if we couldn't fetch a new value for today
    if !new_val and curr.last_updated.to_date < Time.zone.today
      if curr.update_failed
        curr.update_failed = true
        curr.save
      end
    # update value if a new value fetched or today's fetch attempts failed
    elsif curr.val != new_val or curr.update_failed
      curr.val = new_val
      curr.update_failed = false
      curr.last_updated = Time.zone.now
      curr.save
    end
  end
end
