class StatusesController < ApplicationController
  CACHE_TTL = Integer(ENV.fetch("STATUSES_CACHE_TTL", 60))

  def index
    rows = Rails.cache.fetch("judge0/statuses/index", expires_in: CACHE_TTL, race_condition_ttl: 5) do
      Status.all.map { |s| [s.id, s.name] }
    end
    render json: rows.map { |id, name| { id: id, description: name } }
  end
end
