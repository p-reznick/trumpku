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

    case opt
    when 0
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [5, 7, 5])
    when 1
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [8, 9])
    when 2
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [17])
    end

    format_haiku(raw_haiku)
  end

  def format_haiku(text)
    clean_text = text.gsub(/\A\.\s+/, '').gsub(/\.\./, '.')
    pattern = [5, 7, 5]
    lines = []

    clean_text.split.reduce('') do |aggregate, word|
      aggregate.concat(' ' + word)

      if (phrases.get_phrase_syllables(aggregate) === pattern.first)
        lines.push(aggregate)
        pattern.shift
        aggregate = ''
      end

      aggregate
    end

    lines
  end
end
