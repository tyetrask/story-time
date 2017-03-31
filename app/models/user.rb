class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :integrations
  has_many :work_time_units, through: :integrations

  def active_for_authentication?
    super && approved?
  end

end
