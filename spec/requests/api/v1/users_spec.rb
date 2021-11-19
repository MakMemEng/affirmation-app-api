require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'PostAPI' do
    it '全てのポストを取得する' do
      FactoryBot.create_list(:user, 10)

      get '/api/v1/users'
      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # # 正しい数のデータが返されたか確認する。
      # expect(json[].length).to eq(10)
    end

  end

end
