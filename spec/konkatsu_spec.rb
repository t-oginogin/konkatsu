require 'konkatsu'

describe Konkatsu do
  describe 'execute' do
    subject{ Konkatsu.execute(pattern).join(?,) }
    context 'pattern1' do
      # 希望リスト
      let(:pattern) {
        <<-LOVERS
          A:c,b,a
          B:a,b,d
          C:a,c,b
          D:d,a,c
          a:A,C,D
          b:D,A,B
          c:B,A,C
          d:D,C,A
        LOVERS
      }
      it { should eq "A-c,B-b,C-a,D-d" }
    end
    context 'pattern2' do
      # 希望リスト
      let(:pattern) {
        <<-LOVERS
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
      }
      it { should eq "A-a,B-f,C-b" }
    end
  end
end
