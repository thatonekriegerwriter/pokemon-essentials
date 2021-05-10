

#==============================================================================#
#                                                                               
#                         GALAR BERRY TREE Script                               
#                            By BhagyaJyoti                                     
#                       Originally By #Not Important                            
#                           Help from Zeak6464                                  
#                          For Essentials v18                                   
#                         Complete plug-n-play                                  
#                                                                               
#==============================================================================#
                                                                                
def pbCollectionMain
  vbItems=[:SOFTSAND,:SOFTSAND,:SOFTSAND,:SOFTSAND,:STONE,:STONE,:STONE,:STONE,:CHARCOAL,:BIGROOT,:LIGHTCLAY,:BLACKSLUDGE,:DAMPROCK,:SHOALSHELL,:SHOALSALT,:PEARL,:BIGPEARL,:KINGSROCK,:DEEPSEATOOTH,:DEEPSEASCALE,:IRONORE]
  chanceCollect=rand(6)  #Encounters 2/10 of the time
  if  chanceCollect==0 ||  chanceCollect==2 ||  chanceCollect==3 || chanceCollect==5
    vbItem = vbItems[rand(21)]
    pbItemBall(vbItem)
  elsif  chanceCollect==1 ||  chanceCollect==4
    pbMessage("You didn't find anything.")
  end
end
#==============================================================================#
#==============================================================================#

