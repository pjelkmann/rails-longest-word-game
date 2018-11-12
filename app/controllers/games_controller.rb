require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid =  (0...10).map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params["word"]
    @grid = params["grid"]
    @user = read_jason
    @include = include_letters
    @score = calculate_score
  end

  private

  def include_letters
    word = @word.upcase.split('')
    word.all? do |l|
      word.count(l) <= @grid.count(l)
    end
  end

  def read_jason
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    JSON.parse(user_serialized)
  end

  def calculate_score
    if @include == false
      "Sorry but <strong>#{@word}</strong> is not in #{@grid}"
    elsif @user['error']
      "Sorry but <strong>#{@word}</strong> is not an english word"
    elsif @word.empty?
      "Please enter a word!"
    else
      "Congratulations! <strong>#{@word}<strong> is an english word, your score is #{@user['length']}"
    end
  end
end
