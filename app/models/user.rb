# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  team_id                :integer
#  role_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  cost                   :float
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#

class User < ApplicationRecord

  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  belongs_to :team, optional: true
  belongs_to :role, optional: true
  has_many :reports
  has_many :report_parts, through: :reports
  has_many :reporting_periods, through: :reports
  has_many :contracts, through: :report_parts
  has_many :projects, through: :contracts
  has_many :full_reports

  validates_uniqueness_of :email, :name

  private

  def password_required?
    return false if skip_password_validation
    super
  end
end
