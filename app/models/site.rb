class Site < ActiveRecord::Base
  validates :name, length: { minimum: 1, maximum: 21 }, format: { with: /\A[a-z][a-z0-9-]{0,20}\z/, message: ' Name must start with a letter and can only contain lowercase letters, numbers, and dashes. Name must be between 3 to 21 characters.' }
  validates :email, :email => {:strict_mode => true}
end
