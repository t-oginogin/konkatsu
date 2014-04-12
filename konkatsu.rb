# 女性側の希望に含まれているかチェック
def love_match(lovers, man, key)
  lover = lovers[man][key]
  if lover
    if lovers[lover].has_value?(man)
      p "#{man}-#{lover}" 
      return true 
    end
  end
  false 
end

# 入力パターン解析
def input_parse(lovers, input_string)
  input_string.split("\n").each do |lover|
    /(\w):(.+)/.match(lover)
    name = $1
    lovers[name] = {}
    ($2 || "").split(",").each_with_index do |s, i|
      lovers[name][:first] = s if i == 0
      lovers[name][:second] = s if i == 1
      lovers[name][:third] = s if i == 2
    end
  end
end

# 希望リスト
=begin
lovers_string = <<LOVERS
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
lovers_string = <<LOVERS
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

# 希望リスト解析
lovers = {}
input_parse lovers, lovers_string

# 男性の希望をチェック
lovers.each_key do |man|
  next unless /[A-Z]+/.match(man)

  # 1st希望同士のチェック
  first = lovers[man][:first]
  if first
    woman_first = lovers[first][:first]
    if woman_first
      if man == woman_first
        p "#{man}-#{first}" 
        next
      end
    end
  end

  # 希望に含まれているかを第一希望からチェック
  next if love_match lovers, man, :first
  next if love_match lovers, man, :second
  next if love_match lovers, man, :third

end

