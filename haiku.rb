require 'pry'
require 'ruby_rhymes'
require_relative 'phrases'

class Haiku
  attr_accessor :phrases

  def initialize(text)
    self.phrases = Phrases.new(text)
  end

  def get_sample_haiku
    opt = rand(3)
    opt = 2

    case opt
    when 0
      raw_haiku = phrases.get_phrase('start', 5) + "\n" +
                  phrases.get_phrase('mid', 7) + "\n" +
                  phrases.get_phrase('end', 5)
    when 1
      raw_haiku = phrases.get_sentence(5) + "\n" +
                  phrases.get_sentence(7) + "\n" +
                  phrases.get_sentence(5)
    when 2
      phrases.get_splittable_text([5, 7, 5], [17])
    end

    format_haiku(raw_haiku)
  end

  def format_haiku(text)
    haiku = ''
    text.split("\n").map do |line|
      line[0] = line[0].upcase
      line
    end
  end
end

# trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
# h = Haiku.new(trump_path)
# binding.pry
