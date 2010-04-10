require 'set'

module Attachable
  def self.included(base)
    base.send(:attr_accessor, :attachments)
  end
  
  def initialize(options = {})
    @attachments = Set.new []
    
    super
  end
end