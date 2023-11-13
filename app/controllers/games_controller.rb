class GamesController < ApplicationController
  require 'net/http'
  require 'json'

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    grid = params[:word].split("")
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    if !word_in_grid?(@word, grid)
      @result = "Sorry but #{@word} can't be built out of #{@letters}"
    elsif !result["valid"]
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word} is a valid English word."
    end
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end

# app/views/games/new.html.erb.
