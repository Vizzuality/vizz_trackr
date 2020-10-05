# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  admin                  :boolean          default(FALSE)
#  dedication             :float            default(0.74), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  rate_id                :bigint
#  role_id                :integer
#  team_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_rate_id               (rate_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_team_id               (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (rate_id => rates.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (team_id => teams.id)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
