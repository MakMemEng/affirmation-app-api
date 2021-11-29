class Api::V1::PostController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @post = Affirmation.all
  end
end
