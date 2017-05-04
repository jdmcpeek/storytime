Birdv::DSL::ScriptClient.new_script 'day4', 'sms' do

  sequence 'firstmessage' do |recipient|
    txt = 'scripts.intro_sms.__poc__[3]'
    puts "sending intro txt..."
    send recipient, txt,  'firstmessage', 'image1', 'MSG'
    delay recipient, 'image1', SMS_WAIT
  end

  sequence 'image1' do |recipient|
    img = 'mms.stories.chomp[0]'
    puts "sending first image..."
    send recipient, img, 'image1', 'image2', 'IMG'
  end

  sequence 'image2' do |recipient|
    puts "sending second image..."
    img = 'mms.stories.chomp[1]'
    send recipient, img, 'image2', 'IMG'
  end

end 

