Birdv::DSL::ScriptClient.new_script 'remind' do
  #
  # register some buttons for reuse!
  # ================================
  # NOTE: always call story_button, template_generic, 
  # and button_normal OUTSIDE of sequence blocks
  #


  # I should handle resubscribing within the sequence, probably...

  sequence 'remind' do |recipient|
    # greeting with 5 second delay
    txt = 'scripts.remind.__poc__'
    send recipient, text({text:txt}), 'MSG'

  end

  sequence 'unsubscribe' do |recipient|

    txt = 'scripts.subscription.unsubscribe.__poc__'
    send recipient, text({text:txt}), 'MSG'

  end

  sequence 'resubscribe' do |recipient|

    txt = 'scripts.subscription.resubscribe'
    send recipient, text({text:txt}), 'MSG'

    resubscribe recipient

  end



end 

