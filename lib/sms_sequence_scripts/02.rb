Birdv::DSL::ScriptClient.new_script 'day2', 'sms' do

	sequence 'firstmessage' do |recipient|
		txt = 'scripts.first_book.__poc__'
		puts "sending intro txt..."
		send recipient, txt,  'firstmessage', 'image1', 'MSG'
	end

	sequence 'image1' do |recipient|
		img = 'mms.stories.clouds[0]'
		puts "sending first image..."
		send recipient, img, 'image1', 'image2', 'IMG'
	end

	sequence 'image2' do |recipient|
		# one more button
		puts "sending second image..."
		img = 'mms.stories.clouds[1]'
		send recipient, img, 'image2', 'feature-phones', 'IMG'

	end


	sequence 'feature-phones' do |recipient|
		puts "feature phone message..."
		txt = 'feature.messages.opt-in.intro'
		send recipient, txt,  'feature-phones', 'MSG'
	end
end 

