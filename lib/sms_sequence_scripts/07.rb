Birdv::DSL::ScriptClient.new_script 'day7', 'sms' do
  # recipients are phone numbers
  sequence 'firstmessage' do |recipient|
    txt = 'scripts.intro_sms.__poc__[3]'
    puts "sending intro txt..."
    send recipient, txt,  'firstmessage', 'image1', 'MSG'

    # delay the conventional SMS delay
    # delay recipient, 'image1', SMS_WAIT
  end

  sequence 'image1' do |recipient|
    # send out coon story, 'MSG'
    img = 'mms.stories.dino[0]'
    puts "sending first image..."
    send recipient, img, 'image1', 'image2', 'IMG'

    # delay recipient, 'image2', MMS_WAIT
  end

  # No button on the first day! 
  sequence 'image2' do |recipient|
    # one more button
    puts "sending second image..."
    img = 'mms.stories.dino[1]'
    send recipient, img, 'image2', 'IMG'

    # delay recipient, 'goodbye', MMS_WAIT
  end

  # sequence 'goodbye' do |recipient|
  #   puts "saying goodbye..."

  #   txt = 'scripts.outro.__poc__[2]'
  #   send recipient, txt,  'goodbye', 'MSG'
  # end



end 

