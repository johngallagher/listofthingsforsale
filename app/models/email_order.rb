class EmailOrder
  include ActiveModel::Validations

    validates_presence_of :email, :sender_name, :content, :seller_email
    # to deal with form, you must have an id attribute
    attr_accessor :id, :email, :sender_name, :support_type, :content, :seller_email, :order

    def initialize(attributes = {})
      attributes.each do |key, value|
        self.send("#{key}=", value)
      end
      @attributes = attributes
    end

    def read_attribute_for_validation(key)
      @attributes[key]
    end

    def to_key
    end

    def save
      if self.valid?
        Notifier.order_notification(self).deliver!
        return true
      end
      return false
    end
end
