require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z')
    alphabet_array = alphabet.to_a
    @letters = alphabet_array.sample(10)
  end

  def score
    @letters = params[:letters].downcase.split
    @attempt = params[:attempt].downcase

    if is_english_word? && is_valid_word?
      @score = @attempt.length.fdiv(@letters.length) * 100
    else
      @score = 0
    end

    @message = create_message
  end

  private

  def is_english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    api_content = URI.open(url).read
    response = JSON.parse(api_content)
    response["found"]
  end

  def is_valid_word?
    @attempt.chars.all? do |char|
      @attempt.count(char) <= @letters.count(char)
    end
  end

  def create_message
    if is_english_word? && is_valid_word?
      "Congratulations! #{@attempt} is a valid English word."
    elsif is_english_word? && !is_valid_word?
      "Sorry but #{@attempt} can't be built out of #{@letters}"
    elsif !is_english_word? && is_valid_word?
      "Sorry but #{@attempt} does not seem to be a valid English word..."
    else
      "Sorry but #{@attempt} can't be built out of #{@letters}"
    end
  end
end
