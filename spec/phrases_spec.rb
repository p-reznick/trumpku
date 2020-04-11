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

    it '#make_english_word returns correct word' do
      raw_and_correct = [
        ['11', 'eleven'],
        ['car', 'car'],
        ['golf8ball', 'golfeightball'],
        ['1,101', 'one thousand one hundred one'],
      ]

      raw_and_correct.each do |pair|
        expect(phrases.make_english_word(pair[0])).to(eq(pair[1]))
      end
    end

    it '#decimal_to_word returns correct words' do
      decimals_and_words = [
        ['1', 'one'],
        ['2', 'two'],
        ['18', 'eighteen'],
        ['127', 'one hundred twenty seven'],
        ['901', 'nine hundred one'],
        ['920', 'nine hundred twenty'],
        ['0', 'zero'],
        ['91', 'ninety one'],
        ['800000', 'eight hundred thousand'],
        ['20000', 'twenty thousand'],
        ['7823', 'seven thousand eight hundred twenty three'],
        ['906928', 'nine hundred six thousand nine hundred twenty eight'],
        ['77', 'seventy seven'],
      ]

      decimals_and_words.each do |pair|
        expect(phrases.decimal_to_word(pair[0])).to(eq(pair[1]))
      end
    end

    it '#is_acronym? returns whether word is acronym' do
      words_and_acronym = [
        ['cat', false],
        ['CAT', true],
        ['CIA', true],
        ['cia', false],
        ['CIa', false],
      ]

      words_and_acronym.each do |pair|
        expect(phrases.is_acronym?(pair[0])).to(eq(pair[1]))
      end
    end

    it '#get_acronym_syllable_count gets correct syllable count' do
      words_and_count = [
        ['CAT', 3],
        ['CIA', 3],
        ['DARPA', 5],
        ['WNBA', 5],
      ]

      words_and_count.each do |pair|
        expect(phrases.get_acronym_syllable_count(pair[0])).to(eq(pair[1]))
      end
    end

    it '#match_syllable_pattern? matches syllable pattern' do
      text_pattern_match = [
        ['hi there', [2], true],
        ['hi there', [3], false],
        ['hi there friend', [3], true],
        ['et in arcadia ego', [8], true],
        ['et in arcadia ego', [4], false],
        ['et in arcadia ego', [2, 6], true],
        ['et in arcadia ego', [2, 4, 2], true],
        ['et in arcadia ego', [2, 4, 1, 1], false],
      ]

      text_pattern_match.each do |triplet|
        expect(phrases.match_syllable_pattern?(triplet[0], triplet[1])).to(eq(triplet[2]))
      end
    end
  end
end
