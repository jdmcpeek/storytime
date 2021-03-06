require 'facebook/messenger'
require 'httparty'


# load environment vars, db, workers, and STScripts
# load STScripts
# load workers
# require_relative '../config/environment'
# require_relative '../config/initializers/redis'

require_relative 'workers'

# configure facebook-messenger gem 
include Facebook::Messenger


# custom fb helpers that we wrote
require_relative 'helpers/fb'
include Facebook::Messenger::Helpers

require_relative 'helpers/contact_helpers'
include ContactHelpers


STORY_BASE_URL = 'http://d2p8iyobf0557z.cloudfront.net/'


fb_scripts  = Birdv::DSL::ScriptClient.scripts['fb']

require_relative 'helpers/reply_helpers'
include MessageReplyHelpers


def is_image?(message_attachments)
  not message_attachments.nil?
end

# Was the previous message unknown?
def prev_unknown?(user)
  # Look up if bot's last reply was to UNKOWN message
  redis_msg_key = user.fb_id + "_last_message_text"
  users_last_msg = REDIS.get(redis_msg_key)
  puts "users_last_msg = #{users_last_msg}"
  bot_last_reply = get_reply(users_last_msg, user)
  prev_was_unknown  = (bot_last_reply == (I18n.t 'user_response.default')) 

  # Ensure that there also WAS a last message
  prev_was_unknown  = prev_was_unknown && !users_last_msg.nil?
  return prev_was_unknown
end

# demo sequence!
INTRO         = /intro/i
MMS_RQST      = /sms\d+ \d+/i
DEMO          = /\A\s*demo\s*\z/i
END_DEMO      = /\A\s*end\s*demo\s*\z/i
MORE_STORIES  = /\A\s*more\s*\z/i 
JOIN          = /join/i
# link_code     = /\A\s*@\S+\s*\z/i
link_code     = /\A\s*\d{2,3}\s*\z/i


#
# i.e. when user sends the bot a message.
#
Bot.on :message do |message|
  #any image attachment
  attachments = message.attachments

  puts "got a message! #{message}"
  
  if !is_image?(attachments)
    puts "Received #{message.text} from #{message.sender}"
    the_new_msg = message.text
  end

  sender_id = message.sender['id']    

  # enroll user if they don't exist in db
  db_user = User.where(:fb_id => sender_id).first 

  if db_user.nil?
      register_user(message.sender)
      db_user = User.where(:fb_id => sender_id).first 
      if link_code.match(message.text) && LinkedIn_profiles(db_user, message.text)
        puts "the link code matches!"
        StartDayWorker.perform_async(sender_id, 'fb', :greeting)
      else
        # first, check to see if this corresponds to the code they were sent by text... and then schools and teachers
        MessageWorker.perform_async(sender_id, 'day1', :code, 'fb')
      end

  elsif is_image?(attachments) # user has been enrolled already + sent an image
      fb_send_txt(message.sender, ":)")
  else # user has been enrolled already...
      case message.text
      when DEMO
        MessageWorker.perform_async(sender_id, 'demo', :seedgreeting, 'fb')
        REDIS.set(db_user.fb_id + "_demo_storyindex", 0)
      when END_DEMO
        MessageWorker.perform_async(sender_id, 'demo', :enddemo, 'fb')
        REDIS.set(db_user.fb_id + "_demo_storyindex", 0)
      when MORE_STORIES
        story_index = REDIS.get(db_user.fb_id + "_demo_storyindex").to_i % 3 # modulo that shit
        puts "story_index = #{story_index}"
        extra_stories = ['whale', 'chores', 'ants']
        next_story = extra_stories[story_index] + 'greeting'
        MessageWorker.perform_async(sender_id, 'demo', next_story, 'fb')
        REDIS.set(db_user.fb_id + "_demo_storyindex", story_index + 1)
      when DAY_RQST
        script_name = message.text.match(DAY_RQST).to_s.downcase
        if fb_scripts[script_name] != nil
#          fb_scripts[script_name].run_sequence(sender_id, :init)
          MessageWorker.perform_async(sender_id, script_name, :init, platform='fb')
        else
          fb_send_txt(message.sender, "Sorry, that script is not yet available.")
        end
      when MMS_RQST
        code, phone = message.text.scan(/\d+/)
        puts "code = #{code}, phone = #{phone}"
        script = Birdv::DSL::ScriptClient.scripts['sms']["day#{code}"]
        if script
          MessageWorker.perform_async(phone, "day#{code}", :init, platform='sms')
        else
          fb_send_txt(message.sender, "Sorry, that story is not yet available.")
        end

      else # find the appropriate reply

        reply = get_reply(message.text, db_user)

        if reply.include? 'translation missing'
            notify_admins(reply, '')
        end

        fb_send_txt(message.sender, reply) unless reply.nil? or reply.empty? or reply.include? 'translation missing'

        if reply == (I18n.t 'scripts.subscription.resubscribe')
          st_no = db_user.state_table.story_number
          last_unique = db_user.state_table.last_unique_story
          last_unique_read = db_user.state_table.last_unique_story_read?
          # now check if the story they received is one of the uniques....
          if last_unique_read == false
            puts "the last unique story wasn't read, so we must send that one (bot.rb)"
            db_user.state_table.update(last_unique_story_read?: true)
            user_day = "day#{last_unique}"
            MessageWorker.perform_in(2.seconds, sender_id, user_day, :storysequence, 'fb')

          elsif st_no > $story_count # but we have read our last unique story
            # get the button we sent before
            mod = (st_no % $story_count) + 1 # just to be 1-indexed
            user_day = (mod == 1) ? 2 : mod
            user_day = "day#{user_day}"
            MessageWorker.perform_in(2.seconds, sender_id, user_day, :storysequence, 'fb')

          else # PERFORM REGULAR FUNCTION bc they still haven't gone through all stories 
            user_day = "day#{st_no}"
            MessageWorker.perform_in(2.seconds, sender_id, user_day, :storysequence, 'fb')
          end

        end

      end # case message.text
  end # db_user.nil?

  #update the last message
  redis_msg_key = sender_id + "_last_message_text"
  REDIS.set(redis_msg_key, the_new_msg)
   
end

#
# i.e. when user taps a button
#
Bot.on :postback do |postback|
  sender_id = postback.sender['id']
  case postback.payload
  when INTRO
    puts "received payload #{postback.payload}"
    MessageWorker.perform_async(sender_id, 'day1', :code, 'fb')
  else 
    puts "received payload #{postback.payload}"
    # log the user's button press and execute sequence
    script_name, sequence = postback.payload.split('_')
    # puts script_name
    # puts sequence
    MessageWorker.perform_async(sender_id, script_name, sequence, platform='fb')
  end
end


#
# i.e. a reciept from facebook
#
Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end




