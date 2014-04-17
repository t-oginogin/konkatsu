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

  def man?
    from =~ /[A-Z]/
  end

  def love_each_other?(other_pair)
    from == other_pair.to && to == other_pair.from
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

  def search(other_pair)
    all_pairs.map do |pair|
      pair.dup if pair.love_each_other?(other_pair)
    end.compact
  end

  # 女性の希望ポイントを男性の希望ポイントにマージする
  # 女性から希望のあった男性のみ結果用に格納
  def merge_point
    all_pairs.each do |pair|
      unless pair.man?
        men = search(pair)
        men.each {|man| man.point += pair.point; self.love_pairs << man}
      end
    end
  end

  # ポイントの若い順に並び替え
  def sort_by_point
    sorted_pairs = []
    love_pairs.each {|pair| sorted_pairs << pair}
    self.love_pairs = sorted_pairs.sort {|a, b| a.point <=> b.point}
  end

  # 希望順にペアを確定し、すでにペアになった人を除外
  def except_couple
    coupled_names = []
    coupled_pairs = []
    love_pairs.each do |pair|
      is_coupled = false
      coupled_names.each {|name| is_coupled = true if pair.from == name || pair.to == name}
      next if is_coupled
      coupled_names << pair.from
      coupled_names << pair.to
      coupled_pairs << pair 
    end
    self.love_pairs = coupled_pairs
  end

  # 女性から希望されてポイント加算された男性のみ抽出
  def merged_pairs
    sort_by_point
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
