class Invite < ActiveRecord::Base
  has_one :user
  
  before_save :generate_slug
  def generate_slug
    # This is used to generate a random string for the invite
    self.slug = Digest::MD5.hexdigest(Time.now.to_i.to_s) if self.new_record?
  end
end