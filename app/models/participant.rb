class Participant < ApplicationRecord
  include Drivers::Email

  has_many :tickets, dependent: :destroy
  enum status: {
    pending: 0,
    approved: 1
  }

  after_update :send_eticket_email, if: :approved?

  def send_eticket_email
    ticket_email(self)
  end
end
