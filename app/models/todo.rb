class Todo
  include Mongoid::Document

  belongs_to :user

  field :content, type: String
  field :done,    type: Boolean
  field :order,   type: Integer
end
