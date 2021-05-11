################################################################################
############# PLACE THIS IN A NEW SCRIPT SECTION RIGHT ABOVE MAIN! #############
################################################################################

###################################
############# REQUIRED ############
###################################
Events.onMapUpdate+=proc{|sender,e|
  if !$achievementmessagequeue.nil?
    $achievementmessagequeue.each_with_index{|m,i|
      $achievementmessagequeue.delete_at(i)
      Kernel.pbMessage(m)
    }
  end
}

###################################
########### END REQUIRED ##########
###################################
Events.onStepTaken+=proc{|sender,e|
  if !$PokemonGlobal.stepcount.nil?
    Achievements.setProgress("STEPS",$PokemonGlobal.stepcount)
  end
}


