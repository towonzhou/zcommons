# -*- encoding : utf-8 -*-
#数字类
class Numeric

  #转换为特定精度的小数,默认2位
  def to_nf(accuracy = 2)
    return 0.0 unless self
    sprintf("%.0#{accuracy}f",self.to_f)
  end


  #分到元
  def fen_to_yuan
    return 0 unless self
    (self.to_i * 0.01).to_nf(2)
  end

  #元到分

  def yuan_to_fen
    return 0 unless self
    (self.to_f * 100).to_i
  end

  def KB #1,000 bytes
    (self * 1_000)
  end

  def K #1,024 bytes
    (self * 1_024)
  end

  def MB #1,000,000 bytes
    (self * 1_000_000)
  end

  def M #1,048,576 bytes
    (self * 1_048_576)
  end

  def GB #1,000,000,000 bytes
    (self * 1_000_000_000)
  end

  def G #1,073,741,824 bytes
    (self * 1_073_741_824)
  end

  def TB #1,000,000,000,000 bytes
    (self * 1_000_000_000_000)
  end

  def T #1,099,511,627,776 bytes
    (self * 1_099_511_627_776)
  end

end
