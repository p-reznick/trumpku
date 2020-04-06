ONES = %w(zero one two three four five six seven eight nine)
TENS = %w(zero ten twenty thirty forty fifty sixty seventy eighty ninety)
TEENS = {'ten one' => 'eleven',
         'ten two' => 'twelve',
         'ten three' => 'thirteen',
         'ten four' => 'fourteen',
         'ten five' => 'fifteen',
         'ten six' => 'sixteen',
         'ten seven' => 'seventeen',
         'ten eight' => 'eighteen',
         'ten nine' => 'nineteen'}
MULTISYLLABLES = %w(ia io[^n] ua oi ed\z nuclear eo [^aeiou]le\z)

def get_syllable_count(word)
  count = 0
  return 0 if word =~ /\A([?!\-—–'";:$%]|--|——)\z/
  return get_acronym_syllable_count(word) if is_acronym?(word)

  begin
    count = make_english_word(word).to_phrase.syllables
  rescue
    puts "Error thrown with word: #{word}"
  end
    count += 2 if word =~ /[%$]/
    count
end

def get_phrase_syllables(string)
  string.split.inject(0) do |sum, word|
    p string
    sum += get_syllable_count(word)
  end
end

def make_english_word(word)
  return word unless word =~ /\d+/
  word = word.gsub(/,/, '')
  word = word.gsub(/(\d+)/) { decimal_to_word($1) }
end

def get_phrase(phase, num_syllables)
  case phase
  when "start"
    loop do
      phrase = start_phrases.sample
      return phrase if get_phrase_syllables(phrase) == num_syllables
    end
  when "mid"
    loop do
      phrase = mid_phrases.sample
      return phrase if get_phrase_syllables(phrase) == num_syllables
    end
  when "end"
    loop do
      phrase = end_phrases.sample
      return phrase if get_phrase_syllables(phrase) == num_syllables
    end
  end
end

def get_sentence(num_syllables)
  loop do
    sentence = all_sentences.sample
    return sentence if get_phrase_syllables(sentence) == num_syllables
  end
end

def decimal_to_word(word)
  # handles decimal numbers 0 to 999999
  word = word.scan(/\d+/)[0]

  decimal = word.to_s.chars.reverse
  word_arr = []

  decimal.each_with_index do |digit, index|
    if index % 3 == 0
      word_arr.push(ONES[digit.to_i])
    elsif index % 3 == 1
      word_arr.push(TENS[digit.to_i])
    elsif index % 3 == 2
      word_arr.push(ONES[digit.to_i] + ' hundred')
    end
  end
  word_arr.reverse!

  if decimal.count > 3
    word_arr[1] == 'ten' ? insert_idx = 3 : insert_idx = 2
    word_arr = word_arr.insert(insert_idx, 'thousand')
  end

  word_arr.delete_if { |word| word =~ /zero/ } unless word_arr.length == 1

  word_str = word_arr.join(' ')

  TEENS.each do |k, v|
    word_str.gsub!(/#{k}/, v)
  end

  word_str
end

def get_acronym_syllable_count(word)
  count = 0
  count += word =~ /\./ ? word.length / 2 : word.length
  return word =~ /w/i ? count + 1 : count
end

def get_splittable_text(syllable_pattern, sentence_lengths)
  loop do
    full_text = sentence_lengths.reduce('') do |aggregate, length|
      aggregate.concat(get_sentence(length))
    end

    return full_text if match_syllable_pattern?(full_text, syllable_pattern)
  end
end

def match_syllable_pattern?(text, pattern)
  total_lengths = []

  pattern.each_with_index do |length, i|
    total_lengths[i] = pattern[0..i].reduce(:+)
  end

  total_lengths = total_lengths.select do |length|
    length != 0
  end

  match_count = 0

  text.split.reduce('') do |aggregate, word|
    aggregate.concat(' ' + word)
    match_count += 1 if total_lengths.include?(get_syllable_count(aggregate))
    aggregate
  end

  match_count == total_lengths.length
end

def get_syllable_count(word)
  count = 0
  return 0 if word =~ /\A([?!\-—–'";:$%]|--|——)\z/
  return get_acronym_syllable_count(word) if is_acronym?(word)

  begin
    count = make_english_word(word).to_phrase.syllables
  rescue
    puts "Error thrown with word: #{word}"
  end
    count += 2 if word =~ /[%$]/
    count
end

def get_phrase_syllables(string)
  string.split.inject(0) do |sum, word|
    sum += get_syllable_count(word)
  end
end

def is_acronym?(word)
  (word =~ /(\A([A-Z]\.){2,}+\z|\A([A-Z]){2,}+\z)/) ? true : false
end
