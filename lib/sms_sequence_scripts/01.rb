Birdv::DSL::ScriptClient.new_script 'day1', 'sms' do
  # recipients are phone numbers
  sequence 'firstmessage' do |recipient|
    text = 'scripts.intro_sms.__poc__[0]'
    send recipient, text=text,  current='firstmessage', next_sequence='callToAction', 'MSG'
  end

  sequence 'callToAction' do |recipient|
    text = 'scripts.enrollment.call_to_action'
    user = User.where(phone: recipient).first
    send recipient, text,  current='callToAction', 'MSG'
  end

  sequence 'english' do |recipient|
    txt = "*For English, just text 'English'"
    send recipient, txt,  'english', 'MSG'
  end
end