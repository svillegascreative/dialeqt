class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,
    presence: true,
    uniqueness: true,
    format: { with: /^[a-zA-Z0-9](\w|\.)*[a-zA-Z0-9]$/, multiline: true, message: "Not a valid username."},
    length: { in: 4..20 }
end
