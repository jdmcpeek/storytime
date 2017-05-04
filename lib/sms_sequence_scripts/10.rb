Birdv::DSL::ScriptClient.new_script 'day10', 'sms' do
  sequence 'firstmessage' do |recipient|
    txt = 'scripts.intro_sms.__poc__[1]'
    puts "sending intro txt..."
    send recipient, txt,  'firstmessage', 'image1', 'MSG'
  end

  sequence 'image1' do |recipient|
    img = 'mms.stories.moon[0]'
    puts "sending first image..."
    send recipient, img, 'image1', 'IMG'
  end

end 
