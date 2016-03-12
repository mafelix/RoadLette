class User<ActiveRecord::Base
  has_many :searches
  validates :name, presence: true, format: {with: /[a-zA-Z]+\z/}, length: {minimum: 3}
  validates :password, presence: true, format: {with: /\[a-zA-Z]+|\d+\z/}, length: {in: 5..20}
end
