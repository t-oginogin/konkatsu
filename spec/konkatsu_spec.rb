require 'konkatsu'

describe Konkatsu do
  describe 'execute' do
    context 'pattern1' do
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

    context 'pattern2' do
      it 'returns pairs' do

        # 希望リスト
        pattern = <<-LOVERS
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
        expect(lovers.map {|l| l.to_s}.join).to eq("A-cB-fC-bF-a")

      end
    end
  end
end
