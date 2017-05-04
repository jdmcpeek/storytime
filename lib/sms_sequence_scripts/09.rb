Birdv::DSL::ScriptClient.new_script 'day9', 'sms' do
  # recipients are phone numbers
  sequence 'firstmessage' do |recipient|
    txt = 'scripts.intro_sms.__poc__[2]'
    puts "sending intro txt..."
    send recipient, txt,  'firstmessage', 'image1', 'MSG'
  end

  sequence 'image1' do |recipient|
    img = 'mms.stories.floating_shoe[0]'
    puts "sending first image..."
    send recipient, img, 'image1', 'image2', 'IMG'
  end
 
  sequence 'image2' do |recipient|
    puts "sending second image..."
    img = 'mms.stories.floating_shoe[1]'
    send recipient, img, 'image2', 'IMG'
  end

  # sequence 'goodbye' do |recipient|
  #   puts "saying goodbye..."

  #   txt = 'scripts.outro.__poc__[3]'
  #   send recipient, txt,  'goodbye', 'MSG'
  # end

end 




