# Birdv::DSL::ScriptClient.new_script 'demo', 'sms' do


#   # recipients are phone numbers
#   sequence 'firstmessage' do |recipient|
#     txt = "demo.intro"
#     puts "sending intro txt..."

#     # the new way to do it:
#     send recipient, txt,  'image1'

#     # delay the conventional SMS delay
#     # delay recipient, 'image1', SMS_WAIT
#   end


#   sequence 'image1' do |recipient|
#     # send out coon story
#     img = 'https://s3.amazonaws.com/st-messenger/day1/floating_shoe/floating_shoe1.jpg'
#     "sending first image..."

#     # the new way to do it:
#     send recipient, img, 'image2'

#     # delay recipient, 'image2', MMS_WAIT
#   end

#   # No button on the first day! 
#   sequence 'image2' do |recipient|
#     # one more button
#     puts "sending second image..."
#     img = 'https://s3.amazonaws.com/st-messenger/day1/floating_shoe/floating_shoe2.jpg'

#     # the new way to do it:
#     send recipient, img, 'goodbye'

#     # delay recipient, 'goodbye', MMS_WAIT
#   end

#   sequence 'goodbye' do |recipient|
#     puts "saying goodbye..."

#     txt = 'demo.thanks'

#     # the new way to do it:
#     send recipient, txt, 'MSG'
#   end
# end 

