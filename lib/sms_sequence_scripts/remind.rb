Birdv::DSL::ScriptClient.new_script 'remind', 'sms' do
  sequence 'remind' do |recipient|
    # greeting with 5 second delay
    txt = 'scripts.remind_sms.__poc__[0]'
    send recipient, txt,  'remind', 'remind2'
  end

  sequence 'remind2' do |recipient|
    txt = 'scripts.remind_sms.__poc__[1]' 
    send recipient, txt,  'remind2'
  end
end

