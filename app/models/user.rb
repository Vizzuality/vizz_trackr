class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  belongs_to :team, optional: true
  belongs_to :role, optional: true
  has_many :reports
  has_many :report_parts, through: :reports
  has_many :reporting_periods, through: :reports
  has_many :projects, through: :report_parts
end
