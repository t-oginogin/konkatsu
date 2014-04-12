class Lovers
  attr_accessor :man, :woman
  def initialize(init_man, init_woman)
    @man = init_man
    @woman = init_woman
  end

  def to_s
    "#{man}-#{woman}"
  end
end

class LoversPattern
  # 入力パターン解析
  def self.input_parse(input_string)
    lovers_pattern = {}
    input_string.split("\n").each do |lover|
      /(\w):(.+)/.match(lover)
      name = $1
      lovers_pattern[name] = []
      ($2 || "").split(",").each {|s| lovers_pattern[name] << s}
    end
    lovers_pattern
  end
end

class Konkatsu
  attr_accessor :lovers_pattern, :lovers

  def initialize
    @lovers_pattern = {}
    @lovers = []
  end

  # 女性側の希望に含まれているかチェック
  def love_match(man, lank)
    return nil unless lovers_pattern[man]

    if lover = lovers_pattern[man][lank]
      if lovers_pattern[lover].include?(man)
        return Lovers.new(man, lover)
      end
    end
    nil
  end


  def execute( pattern )
    # 希望リスト解析
    @lovers_pattern = LoversPattern.input_parse pattern

    # 男性の希望をチェック
    lovers_pattern.each_key do |man|
      next unless /[A-Z]+/.match(man)

      # 1st希望同士のチェック
      if first = lovers_pattern[man].first
        if woman_first = lovers_pattern[first].first
          if man == woman_first
            lovers << Lovers.new(man, first)
            next
          end
        end
      end

      # 希望に含まれているかを第一希望からチェック
      # ToDo:第n希望まであるかはLoversPatternに判断させたい
      if lover = love_match(man, 0)
        lovers << lover and next
      end
      if lover = love_match(man, 1)
        lovers << lover and next
      end
      if lover = love_match(man, 2)
        lovers << lover and next
      end
    end

    lovers
  end
end

# 希望リスト
=begin
pattern = <<LOVERS
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
LOVERS
=end
pattern = <<LOVERS
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
LOVERS

konkatsu = Konkatsu.new
lovers = konkatsu.execute pattern
lovers.each {|lover| puts lover}

