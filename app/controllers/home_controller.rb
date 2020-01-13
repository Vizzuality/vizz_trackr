class HomeController < ApplicationController
  def index
    @quote = RANDOM_QUOTES.sample
  end
end
