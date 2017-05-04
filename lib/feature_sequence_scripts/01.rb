Birdv::DSL::ScriptClient.new_script 'day1', 'feature' do
  # recipients are phone numbers
  sequence 'firstmessage' do |phone_no|
    text = 'scripts.intro_sms.__poc__[0]'
    send_sms phone_no, text=text, current='firstmessage', next_sequence='callToAction'
  end

  sequence 'callToAction' do |phone_no|
    text = 'scripts.enrollment.call_to_action'
    user = User.where(phone: phone_no).first
    send_sms phone_no, text, current='callToAction'
  end

  sequence 'english' do |phone_no|
    txt = "*For English, just text 'English'"
    send_sms phone_no, txt, 'english'
  end

end