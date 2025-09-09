class TeamMembership < ApplicationRecord
  belongs_to :operator
  belongs_to :team
end
