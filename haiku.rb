require 'pry'
require 'ruby_rhymes'
require_relative 'phrases'

class Haiku
  attr_accessor :phrases

  def initialize(text)
    self.phrases = Phrases.new(text)
  end

  def get_sample_haiku
    opt = 1

    case opt
    when 1
      raw_haiku = phrases.get_phrase('start', 5) + "\n" +
                  phrases.get_phrase('mid', 7) + "\n" +
                  phrases.get_phrase('end', 5)
    when 2
      # raw_haiku = phrases.get_phrase('start', )
    end

    format_haiku(raw_haiku)
  end

  def format_haiku(text)
    haiku = ''
    # words = text.gsub(/"/, '').split
    #
    # words.each do |word|
    #   next if word =~ /[\-—–]/
    #   haiku.concat(word + ' ')
    #   haiku.concat("\n") if get_phrase_syllables(haiku) == 5 ||
    #                         get_phrase_syllables(haiku) == 12
    # end
    #
    # haiku.rstrip!.concat('.')
    p text
    text.split("\n").map do |line|
      line[0] = line[0].upcase
      line
    end
  end
end

# trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
# h = Haiku.new(trump_path)
# binding.pry
