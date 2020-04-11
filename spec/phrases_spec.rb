require_relative '../phrases'

TRUMP_PATH = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'

RSpec.describe Phrases do
  phrases = Phrases.new(TRUMP_PATH)

  describe 'Phrases' do
    it 'evaluate true to be true' do
      expect(true).to(eq(true))
    end

    it '#get_syllable_count returns correct number of syllables for simple words' do
      words_and_counts = [
        ['dog', 1],
        ['cat', 1],
        ['houseboat', 2],
        ['guatamala', 4],
        ['corcoran', 3],
        ['tsar', 1],
        ['baroque', 2],
        ['catamaran', 4],
        ['', 0],
      ]

      words_and_counts.each do |pair|
        expect(phrases.get_syllable_count(pair[0])).to(eq(pair[1]))
      end
    end

    it '#get_syllable_count returns correct number of syllables for numbers in digits' do
      numbers_and_counts = [
        ['1', 1],
        ['2', 1],
        ['18', 2],
        ['127', 7],
        ['0', 2],
        ['91', 3],
        ['1100025', 9],
        ['77', 5],
      ]

      numbers_and_counts.each do |pair|
        expect(phrases.get_syllable_count(pair[0])).to(eq(pair[1]))
      end
    end

    it '#get_syllable_count returns correct number of syllables for numbers ' do
      words_and_counts = [
        ['one', 1],
        ['two', 1],
        ['eighteen', 2],
        ['one hundred twenty seven', 7],
        ['zero', 2],
        ['ninety one', 3],
        ['one million one hundred twenty five', 9],
        ['seventy seven', 5],
      ]

      words_and_counts.each do |pair|
        expect(phrases.get_syllable_count(pair[0])).to(eq(pair[1]))
      end
    end

    it '#get_phrase_syllables returns correct number of syllables' do
      phrases_and_counts = [
        ['dog eats dog', 3],
        ['cat is happy here', 5],
        ['houseboat', 2],
        ['guatamala is in latin america', 12],
        ['corcoran is an art museum', 9],
        ['tsar tsar tesseract', 5],
        ['baroque art is super fancy', 8],
        ['blade runner is nothing if not problematic', 12],
        ['there are one thousand ways to cook rice', 9],
        ['there are 1000 ways to cook rice', 9],
      ]

      phrases_and_counts.each do |pair|
        expect(phrases.get_phrase_syllables(pair[0])).to(eq(pair[1]))
      end

    end
  end
end
