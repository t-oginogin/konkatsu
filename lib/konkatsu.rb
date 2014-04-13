class Lovers
  attr_accessor :from, :to, :point, :is_merged
  def initialize(init_from, init_to, init_point)
    @from = init_from
    @to = init_to
    @point = init_point
    @is_merged = false
  end

  def to_s
    "#{from}-#{to}"
  end

  def man?
    from =~ /[A-Z]+/
  end

  def merged?
    is_merged
  end
end

class LoversPattern
  attr_accessor :lovers

  def initialize
    @lovers = []
  end

  # 入力パターン解析
  def parse(input_string)
    @lovers = []
    input_string.each_line do |lover_list|
      /(\w):(.+)/.match(lover_list)
      name = $1
      ($2 || "").split(",").each_with_index do |lover, i|
        lovers << Lovers.new(name, lover, i+1)
      end
    end
  end

  def search(from, to)
    lists = []
    lovers.each do |lover|
      lists << lover if lover.from == from && lover.to == to
    end
    lists
  end

  # 女性の希望ポイントを男性の希望ポイントにマージする
  def merge_point
    lovers.each do |lover|
      unless lover.man?
        men = search(lover.to, lover.from)
        men.each {|man| man.point += lover.point; man.is_merged = true}
      end
    end
  end

  # 女性から希望されてポイント加算された男性のみ抽出
  def merged_lovers
    # 女性から希望された男性のみ抽出し、ポイントの若い順に並び替え
    sorted_lovers = []
    lovers.each {|lover| sorted_lovers << lover if lover.merged?}
    sorted_lovers.sort! {|a, b| a.point <=> b.point}

    # すでにペアになった人を除外
    coupled_names = []
    each_lovers = []
    sorted_lovers.each do |lover|
      is_coupled = false
      coupled_names.each {|name| is_coupled = true if lover.from == name || lover.to == name}
      next if is_coupled
      coupled_names << lover.from
      coupled_names << lover.to
      each_lovers << lover
    end

    # 名前順に並び替え
    each_lovers.sort {|a, b| a.from <=> b.from}
  end
end

class Konkatsu
  def execute( pattern )
    initialize

    lovers_pattern = LoversPattern.new
    lovers_pattern.parse pattern
    lovers_pattern.merge_point
    lovers_pattern.merged_lovers
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
lovers = konkatsu.execute pattern1
lovers.each {|lover| puts lover}
#2nd
puts "\n2st"
lovers = konkatsu.execute pattern2
lovers.each {|lover| puts lover}
