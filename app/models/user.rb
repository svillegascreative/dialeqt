class User < ApplicationRecord
  include Voter
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,
    presence: true,
    uniqueness: true,
    format: { with: /^[a-zA-Z0-9](\w|\.)*[a-zA-Z0-9]$/, multiline: true, message: "has an invalid character or combination of characters"},
    length: { in: 4..20 }

end
