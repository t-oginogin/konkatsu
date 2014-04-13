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
    from =~ /[A-Z]+/
  end
end

class PairsPattern

  # 入力パターン解析
  def self.parse(input_string)
    pairs = []
    input_string.each_line do |pair_list|
      /(\w):(.+)/.match(pair_list)
      name = $1
      ($2 || "").split(",").each_with_index do |pair, i|
        pairs << Pair.new(name, pair, i+1)
      end
    end
    pairs
  end

end

class Konkatsu
  attr_accessor :all_pairs, :love_pairs

  def initialize
    @all_pairs = []
    @love_pairs = []
  end

  def search(from, to)
    lists = []
    all_pairs.each do |pair|
      lists << pair.dup if pair.from == from && pair.to == to
    end
    lists
  end

  # 女性の希望ポイントを男性の希望ポイントにマージする
  # 女性から希望のあった男性のみ結果用に格納
  def merge_point
    all_pairs.each do |pair|
      unless pair.man?
        men = search(pair.to, pair.from)
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

# 希望リスト
pattern1 = <<LOVERS1
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
LOVERS1

pattern2 = <<LOVERS2
A:c,a,b
B:c,f,a
C:f,c,b
D:d,d,d
E:
F:e,c,a
a:A,D,F
b:C,B,A
c:D,A,C
d:A,A,B
e:C,A,E
f:D,B,A
LOVERS2

konkatsu = Konkatsu.new
#1st
puts "1st"
pairs = konkatsu.execute pattern1
pairs.each {|pair| puts pair}
#2nd
puts "\n2st"
pairs = konkatsu.execute pattern2
pairs.each {|pair| puts pair}
