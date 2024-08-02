class BaseError < StandardError
  attr_accessor :attr, :message

  def initialize(attr = :attribute, message = "default message")
    @attr, @message = attr, message
  end

  def call
    { attr => [message] }
  end
end
