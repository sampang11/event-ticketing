class Attendance < ApplicationRecord
  belongs_to :ticket

  enum status: {
    absent: 0,
    entered: 1
  }
end
