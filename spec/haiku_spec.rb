require_relative '../haiku'

TRUMP_PATH = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'

RSpec.describe Haiku do
  haiku = Haiku.new(TRUMP_PATH)

  it '#get_sample_haiku returns array with three elements' do
    lines = haiku.get_sample_haiku

    expect(lines.length).to(eq(3))
  end

  it '#get_sample_haiku returns array whose elems match 5 7 5 syllable pattern' do
    lines = haiku.get_sample_haiku

    lines_0_syllable_count = haiku.phrases.get_phrase_syllables(lines[0])
    lines_1_syllable_count = haiku.phrases.get_phrase_syllables(lines[1])
    lines_2_syllable_count = haiku.phrases.get_phrase_syllables(lines[2])

    expect(lines_0_syllable_count).to(eq(5))
    expect(lines_1_syllable_count).to(eq(7))
    expect(lines_2_syllable_count).to(eq(5))
  end

  it '#get_raw_haiku consistently returns phrase with 17 syllables' do
    lines = haiku.get_raw_haiku
    syllable_count_0 = haiku.phrases.get_phrase_syllables(lines)
    syllable_count_1 = haiku.phrases.get_phrase_syllables(lines)
    syllable_count_2 = haiku.phrases.get_phrase_syllables(lines)
    syllable_count_3 = haiku.phrases.get_phrase_syllables(lines)

    expect(syllable_count_0).to(eq(17))
    expect(syllable_count_1).to(eq(17))
    expect(syllable_count_2).to(eq(17))
    expect(syllable_count_3).to(eq(17))
  end
end
