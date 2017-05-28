require 'pry'
require 'ruby_rhymes'

class Phrases
  attr_accessor :all, :start_phrases, :mid_phrases, :end_phrases, :text

  def initialize(text)
    self.text = get_clean_text(text)
    self.start_phrases = get_start_phrases
    self.mid_phrases = get_mid_phrases
    self.end_phrases = get_end_phrases
  end

  def get_clean_text(text)
    text.gsub("\n", '')
  end

  def get_start_phrases
    text.scan(/\.\s+[a-z '-]+/i)
  end

  def get_mid_phrases
    text.scan(/[,]\s[^,.;]+[.,]/i)
  end

  def get_end_phrases
    text.scan(/[a-z '-]+\.\s/i)
  end
end

p = Phrases.new("All day long we seemed to dawdle through a country which was full of
beauty of every kind. Sometimes we saw little towns or castles on the
top of steep hills such as we see in old missals; sometimes we ran by
rivers and streams which seemed from the wide stony margin on each side
of them to be subject to great floods. It takes a lot of water, and
running strong, to sweep the outside edge of a river clear. At every
station there were groups of people, sometimes crowds, and in all sorts
of attire. Some of them were just like the peasants at home or those I
saw coming through France and Germany, with short jackets and round hats
and home-made trousers; but others were very picturesque. The women
looked pretty, except when you got near them, but they were very clumsy
about the waist. They had all full white sleeves of some kind or other,
and most of them had big belts with a lot of strips of something
fluttering from them like the dresses in a ballet, but of course there
were petticoats under them. The strangest figures we saw were the
Slovaks, who were more barbarian than the rest, with their big cow-boy
hats, great baggy dirty-white trousers, white linen shirts, and enormous
heavy leather belts, nearly a foot wide, all studded over with brass
nails. They wore high boots, with their trousers tucked into them, and
had long black hair and heavy black moustaches. They are very
picturesque, but do not look prepossessing. On the stage they would be
set down at once as some old Oriental band of brigands. They are,
however, I am told, very harmless and rather wanting in natural
self-assertion.")

binding.pry
