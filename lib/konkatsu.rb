class Pair
  attr_accessor :from, :to, :point
  def initialize(init_from, init_to, init_point)
    @from = init_from
    @to = init_to
    @point = init_point
  end

  def to_s
    "#{from}-#{to}"
  end

  def woman?
    from =~ /[a-z]/
  end

  def love_each_other?(other_pair)
    from == other_pair.to && to == other_pair.from
  end

  def <=>(other)
    point <=> other.point
  end

  def person_exists?(other_pair)
    from == other_pair.from or to == other_pair.to
  end
end

class PairsPattern

  # 入力パターン解析
  def self.parse(input_string)
    input_string.each_line.map do |pair_list|
      /(?<name>\w):(?<others>.+)/ =~ pair_list
      (others || "").split(",").each_with_index.map do |pair, i|
        Pair.new(name, pair, i)
      end
    end.flatten
  end

end

class Konkatsu
  attr_accessor :all_pairs, :love_pairs

  def initialize
    @all_pairs = []
    @love_pairs = []
  end

  def search_men_for_this_woman(woman)
    all_pairs.select {|man| man.love_each_other?(woman) }
  end

  # 女性の希望ポイントを男性の希望ポイントにマージする
  # 女性から希望のあった男性のみ結果用に格納
  def merge_point
    all_pairs.each do |person|
      if person.woman?
        men = search_men_for_this_woman(person)
        men.each do |man|
          man.point += person.point
          self.love_pairs << man
        end
      end
    end
  end

  # 希望順にペアを確定し、すでにペアになった人を除外
  def except_couple
    coupled_pairs = []
    self.love_pairs = love_pairs.select do |pair|
      if coupled_pairs.none? {|coupled_pair| pair.person_exists?(coupled_pair) }
        coupled_pairs << pair
      end
    end
  end

  # 女性から希望されてポイント加算された男性のみ抽出
  def merged_pairs
    # ポイントの若い順に並び替え
    love_pairs.sort!
    except_couple

    # 名前順に並び替え
    love_pairs.sort {|a, b| a.from <=> b.from}
  end
  
  def execute( pattern )
    initialize
    self.all_pairs = PairsPattern.parse pattern
    merge_point
    merged_pairs
  end
end
