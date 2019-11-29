class HomeController < ApplicationController
  def index
		@quote = RANDOM_QUOTES.shuffle.first
  end
end
