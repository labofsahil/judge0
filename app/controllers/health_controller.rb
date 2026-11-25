class HealthController < ApplicationController
  def workers
    json = []
    process_set = Sidekiq::ProcessSet.new
    Sidekiq::Queue.all.each do |queue|
      busy = process_set.count { |p| p.queues.include?(queue.name) }
      json << {
        queue: queue.name,
        size: queue.size,
        available: busy,
        idle: process_set.count { |p| p.queues.include?(queue.name) && !p.busy? },
        working: process_set.count(&:busy?),
        paused: process_set.count(&:stopped?)
      }
    end

    render json: json
  end
end
