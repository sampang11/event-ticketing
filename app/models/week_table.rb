class WeekTable < ApplicationRecord
  belongs_to :team
  belongs_to :competition
  enum result: {
    lost: 0,
    draw: 1,
    win: 2
  }
end
