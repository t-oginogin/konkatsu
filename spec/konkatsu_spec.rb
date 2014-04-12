require 'konkatsu'

describe Konkatsu do
  describe 'execute' do
    it 'returns pairs' do

      # 希望リスト
      pattern = <<-LOVERS
      A:c,b,a
      B:a,b,d
      C:a,c,b
      D:d,a,c
      a:A,C,D
      b:D,A,B
      c:B,A,C
      d:D,C,A
      LOVERS

      konkatsu = Konkatsu.new
      lovers = konkatsu.execute pattern
      expect(lovers.map {|l| l.to_s}.join).to eq("A-cB-bC-aD-d")

    end
  end
end
