Birdv::DSL::ScriptClient.new_script 'day18' do


  button_story({
    name:     'tap_here',
    title:    'scripts.buttons.title[0]',
    image_url:  'scripts.buttons.story_img_url', 
    buttons:  [postback_button('scripts.buttons.tap', script_payload(:storysequence))]
  })


  sequence 'greeting' do |recipient|
    txt = 'scripts.intro.__poc__[1]'
    send recipient, text({text:txt}), 'MSG'
    delay recipient, 'storybutton', 3.seconds
  end

  sequence 'storybutton' do |recipient|   
    # send tap_here button
    send recipient, button({name:'tap_here'})
  end

  sequence 'storysequence' do |recipient|
    
    # send out story
    send recipient, story(), 'IMAGE'

    # delay 'thanks'
    delay recipient, 'thanks', 23.seconds
  end

  sequence 'thanks' do |recipient|
    # one more button
    # send recipient, button({name:'thanks'})
    txt = 'scripts.outro.__poc__[3]'
    send recipient, text({text:txt}), 'MSG'
  end

  sequence 'yourwelcome' do |recipient|
    send recipient, text({text:'scripts.buttons.welcome'})
  end
end 