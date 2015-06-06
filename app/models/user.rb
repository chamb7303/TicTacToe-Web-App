class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String # name

  def self.find_or_instantiate(selector)
    User.where(selector).first || User.new(selector)
  end
end