class HealthController < ApplicationController
  def workers
    json = []
    process_set = Sidekiq::ProcessSet.new
    Sidekiq::Queue.all.each do |queue|
      subscribed = process_set.select { |p| p.queues.include?(queue.name) }
      json << {
        queue: queue.name,
        size: queue.size,
        available: subscribed.count { |p| !p["busy"] },
        idle: subscribed.count { |p| !p["busy"] },
        working: subscribed.count { |p| p["busy"] },
        paused: subscribed.count(&:stopping?)
      }
    end

    render json: json
  end
end
