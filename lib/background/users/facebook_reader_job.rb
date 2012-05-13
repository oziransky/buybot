#performs asynchronous collection of Facebook Information
#for given user.

require 'log4r'
include Log4r

class FacebookReaderJob < Struct.new(:user_id)

	def perform

    logger = Log4r::Logger[Rails.env]
		logger.debug "Collecting facebook info for user #{user_id}"
		
		user = User.find(user_id)
		
		if user.access_token.nil?
			logger.warning "User #{user_id} has no facebook access token"
		else
			fb_profile = Facebook.profile user.access_token
			fb_info = user.facebook_info.nil? ? user.create_facebook_info : user.facebook_info


			#set name
			fb_info.name=fb_profile.name

      fb_info.gender=fb_profile.gender

      fb_info.name = fb_profile.name
      fb_info.birthday = fb_profile.birthday
      fb_info.gender = fb_profile.gender
      fb_info.relationship = fb_profile.relationship_status
      fb_info.location = fb_profile.location.name unless fb_profile.location.nil?
      fb_info.phone_number = fb_profile.mobile_phone
      fb_info.friends_count = fb_profile.friends.size
      fb_info.interests = fb_profile.interests.collect {|interest| interest.name}
			
			
			
			fb_info.save!
		end

			
	end
end
