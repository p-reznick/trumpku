require 'pry'
require 'ruby_rhymes'
require_relative 'phrases'

class Haiku
  attr_accessor :phrases

  def initialize(text)
    self.phrases = PhraseManager.new(text)
  end

  def get_raw_haiku
    opt = rand(5)

    case opt
    when 0
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [5, 7, 5])
    when 1
      a = rand(5) + 5
      b = 17 - a
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [a, b])
    when 2
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [17])
    when 3
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [12, 5])
    when 4
      raw_haiku = phrases.get_splittable_text([5, 7, 5], [5, 12])
    end

    raw_haiku
  end

  def get_sample_haiku
    format_haiku(get_raw_haiku)
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
