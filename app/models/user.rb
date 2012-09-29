class User
  include Mongoid::Document

  has_many :todo

  field :first_name, type: String
  field :last_name, type: String
  field :pic_url, type: String
end