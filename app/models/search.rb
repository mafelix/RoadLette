class Search<ActiveRecord::Base
  belongs_to :user
  
  validates :price, presence: true
  validates :days, presence: true

end
