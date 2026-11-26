require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do
  describe "GET #index" do
    it "returns all languages" do
      create_list(:language, 10)
      get :index
      json = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json).to eq(Language.order(:id).map { |l| { "id" => l.id, "name" => l.name } })
    end
  end
end
