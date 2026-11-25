class LanguagesController < ApplicationController
  CACHE_TTL = Integer(ENV.fetch("LANGUAGES_CACHE_TTL", 60))

  def index
    rows = Rails.cache.fetch("judge0/languages/index", expires_in: CACHE_TTL, race_condition_ttl: 5) do
      Language.order(:id).pluck(:id, :name)
    end
    render json: rows.map { |id, name| { id: id, name: name } }
  end

  def all
    rows = Rails.cache.fetch("judge0/languages/all", expires_in: CACHE_TTL, race_condition_ttl: 5) do
      Language.unscoped.order(:name).pluck(:id, :name, :is_archived)
    end
    render json: rows.map { |id, name, archived| { id: id, name: name, is_archived: archived } }
  end

  def show
    render json: Language.unscoped.find(params[:id])
  end
end
