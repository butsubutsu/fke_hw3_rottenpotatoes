ppp=["R", "R", "R", "PG", "PG"]
uuu=["R", "G"]
uuu.each do |k|
  p "!!"+k
  p ppp.select{|u| u=~/^#{k}$/o}
  p ppp.select{|u| u=~/^#{k}$/}
  #p ppp.select{|u| u=~/"k"/}
end 
