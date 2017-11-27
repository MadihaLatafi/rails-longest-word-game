require 'open-uri'
require 'json'
require 'time'

class PagesController < ApplicationController
  def game
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @attempt = params[:attempt]
    @grid = params[:grid]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now

    @result = { time: @end_time - @start_time }
    @time = @result[:time]


    if @attempt.upcase.chars.all? { |letter| @attempt.count(letter) <= @grid.count(letter) }
        response = open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
        json = JSON.parse(response.read)
      if json['found']
        @time > 60.0 ? (@score = 0) : (@score = @attempt.size * (1.0 - @time / 60.0))
        @score_and_message = [@score, "well done"]
      else
        @score_and_message = [0, "not an english word"]
      end
    else
      @score_and_message = [0, "not in the grid"]
    end

    @result[:score] = @score_and_message.first
    @result[:message] = @score_and_message.last

    @result

  end

end

