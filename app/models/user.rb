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
#  admin                  :boolean          default(FALSE)
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

  def current_report
    reporting_period = ReportingPeriod.where(aasm_state: 'active').first
    return nil unless reporting_period

    reports.where(reporting_period_id: reporting_period.id).first || reports
      .create(reporting_period_id: reporting_period.id, estimated: true,
              role_id: role_id, team_id: team_id)
  end

  private

  def password_required?
    return false if skip_password_validation

    super
  end
end
