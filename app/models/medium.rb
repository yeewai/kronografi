class Medium < ActiveRecord::Base
  has_attached_file :content, :default_url => "/images/missing.png"
  validates_attachment_content_type :content, :content_type => /\Aimage\/.*\Z/
end
