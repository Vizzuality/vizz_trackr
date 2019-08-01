class User < ApplicationRecord
  belongs_to :team
  belongs_to :roles
end
