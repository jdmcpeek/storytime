require_relative 'helpers/auth.rb'
require_relative 'helpers/phone-email.rb'
require_relative '../lib/api/helpers/authentication'
require_relative '../lib/helpers/is_not_us'

class User < Sequel::Model(:users)
  include PersonIsNotUs
  include AuthenticateModel
  include AuthenticationHelpers
  extend SearchByUsername


	plugin :timestamps, :create=>:enrolled_on, :update=>:updated_at, :update_on_create=>true
	plugin :validation_helpers
	plugin :association_dependencies
	plugin :json_serializer

	many_to_one :classroom
	many_to_one :teacher
	many_to_one :school
	one_to_many :button_press_logs
	one_to_one :enrollment_queue
	one_to_one :state_table

	add_association_dependencies enrollment_queue: :destroy, button_press_logs: :destroy, state_table: :destroy




  def set_reset_password_token(token)
    return false if token.empty? or token.nil?
    digest = Password.create(token)
    self.update(reset_password_token_digest: digest)
    return digest
  end




  def authenticate_reset_password_token(tkn=nil)
    begin
      return false if tkn.nil? || tkn.empty?
      # return false if self.password_digest.nil?
      digest  = self.reset_password_token_digest
      db_token   = Password.new(digest)

      return db_token == tkn
    rescue => e
      p e
      return false
    end
  end






	def story_number
		self.state_table.story_number
	end





	def generate_code
		Array.new(2){[*'0'..'9'].sample}.join
	end





	# ensure that user is added EnrollmentQueue upon creation
	def after_create
		super
		# associate an enrollment queue
		eq = EnrollmentQueue.create(user_id: self.id)
		self.enrollment_queue = eq
		eq.user = self
		# associate a state table
		st = StateTable.create(user_id: self.id)
		self.state_table = st
		st.user = self


    if not ['app', 'android', 'ios'].include? self.platform
		  # self.state_table.update(subscribed?: false) unless ENV['RACK_ENV'] == 'test'
      # self.state_table.update(subscribed?: true)
    end

		if not ['fb', 'app', 'android', 'ios'].include? self.platform
			self.code = generate_code
		end
		# puts "start code = #{self.code}"
		while !self.valid?
			self.code = (self.code.to_i + 1).to_s
			# puts "new code = #{self.code}"
		end
		# set default curriculum version
		ENV["CURRICULUM_VERSION"] ||= '0'
		self.update(curriculum_version: ENV["CURRICULUM_VERSION"].to_i)

		# we would want to do
		# self.save_changes
		# self.state_table.save_changes
		# but this is already done for us with self.update and self.state_table.update

	rescue => e
		p e.message + " could not create and associate a state_table, enrollment_queue, or curriculum_version for this user"
	end






	def match_school(body_text)
      School.each do |school|
        code = school.code
        if code.nil?
          next
        end
        code = code.delete(' ').delete('-').downcase
        # body_text = params[:Body].delete(' ')
        #                          .delete('-')
        #                          .downcase

        if code.include? body_text
          en, sp = code.split('|')
          if body_text == en
            # puts "WE HAVE A MATCH! User #{phone} goes to #{school.signature}"
            I18n.locale = 'en'
            # puts "school info: #{school.signature}, #{school.inspect}"
            school.add_user(self)
            return school
          elsif body_text == sp
            # puts "WE HAVE A MATCH! User #{phone} goes to #{school.signature}"
            I18n.locale = 'es'
            self.update(locale: 'es')
            # puts "school info: #{school.signature}, #{school.inspect}"
            school.add_user(self)
            return school
          else
            puts "#{code} did not match with #{school.name} regex!"
          end
        else
          puts "code #{body_text} doesn't match with #{school.signature}'s code #{school.code}"
        end
      end
  end






  def match_teacher(body_text)

      Teacher.each do |teacher|
        code = teacher.code
        if code.nil?
          next
        end
        code = code.delete(' ').delete('-').downcase
        # body_text = params[:Body].delete(' ')
        #                          .delete('-')
        #                          .downcase

        if code.include? body_text
          en, sp = code.split('|')
          if body_text == en
            I18n.locale = 'en'
            teacher.add_user(self)
            if !teacher.school.nil? # if this teacher belongs to a school
              teacher.school.add_user(self)
            end
            return teacher

          elsif body_text == sp
            I18n.locale = 'es'
            self.update(locale: 'es')
            # puts "teacher info: #{teacher.signature}, #{teacher.inspect}"
            teacher.add_user(self)
            if !teacher.school.nil? # if this teacher belongs to a school
              teacher.school.add_user(self)
            end
            return teacher
          else
            puts "#{code} did not match with #{teacher.name} regex!"
          end
        else
          puts "code #{body_text} doesn't match with #{teacher.signature}'s code #{teacher.code}"
        end # if code.include? body_text
      end # Teacher.each do |teacher|

  end


	def validate
    super
    validates_unique :code, :allow_nil=>true, :message => "#{code} is already taken (users)"
    validates_unique :phone, :allow_nil=>true, :message => "#{phone} is already taken (users)"
    validates_unique :email, :allow_nil=>true, :message => "#{email} is already taken (users)"
    validates_unique :fb_id, :allow_nil=>true, :message => "#{fb_id} is already taken (users)"
  end

end














