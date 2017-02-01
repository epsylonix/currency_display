class BroadcastChangeJob < ApplicationJob
  queue_as :default

  def perform(curr)
    ActionCable.server.broadcast('currencies', 
        {
          code: curr.code,
          body: ApplicationController.new.render_to_string(
                               'shared/_currency', 
                               layout: false, 
                               :locals => {:curr => curr}),
          update_failed: (curr.update_failed and !curr.forced)
        })
  end

end
