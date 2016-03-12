class Search<ActiveRecord::Base
  belongs_to :user

  validates :price, presence: true, numericality: {only_integer: true}
  validates :days, presence: true, numericality: {only_integer: true}

end
