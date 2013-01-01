class Shop < ActiveRecord::Base
  has_attached_file :profile_photo, :styles => {:profile => "270x220>"}, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml", :path => "/:style/:id/:filename"
  has_friendly_id :url, :use_slug => true

  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of :url, :with => /^[A-Za-z\-_0-9]+$/, :message => "only letters/numbers please"
  validates_length_of :url, :maximum => 30, :minimum => 4, :message => "4-30 characters please"

  attr_accessor :description_for_shop, :publishing_errors
  has_many :items
  belongs_to :user
  has_many :orders
  has_one :background, :class_name => "Background", :foreign_key => "id"

  after_initialize :init

  def init
    self.status ||= ShopStatus::Offline
    self.payment_type ||= Payments::Paypal
    self.publishing_errors ||= []
    self.about_me ||= "Write whatever you want here. You could use it to tell people who you are and what you are selling. If you have a retail presence or a market stall, you could put up the details up here."
  end

  def profile_photo_height
    Paperclip::Geometry.from_file(profile_photo.to_file(:profile)).height
  end

  def before_save
    self.url.downcase!
  end
end
