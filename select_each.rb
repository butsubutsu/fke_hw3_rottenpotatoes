ppp=["R", "R", "R", "PG", "PG"]
uuu=["R", "G"]
uuu.each do |k|
  p "!!"+k
  p ppp.select{|u| u=~/^#{k}$/o}
  p ppp.select{|u| u=~/^#{k}$/}
  #p ppp.select{|u| u=~/"k"/}
end 
aaa=[0,1,2,3,4,5]
aaa.each{|x,y| p x.to_s+'~'+y.to_s}
bbb=aaa.reverse
p bbb.sort
