class User < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :role, optional: true
end
