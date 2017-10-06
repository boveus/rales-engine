class Transaction < ApplicationRecord
  acts_as_copy_target
  belongs_to :invoice

  scope :success, ->{ where(result: 'success') }
  scope :failure, ->{ where(result: 'failure') }

  def self.find_transaction(params)
    find_by(params)
  end

  def self.find_all(params)
    where(params)
  end
  
end
