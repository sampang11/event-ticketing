class Participant < ApplicationRecord
  include Drivers::Email
  include EmailValidatable

  has_many :tickets, dependent: :destroy
  enum status: {
    pending: 0,
    approved: 1
  }

  validates_presence_of :full_name, :email, :e_transfer_number
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  after_update :send_eticket_email, if: :approved?

  def send_eticket_email
    ticket_email(self)
  end
end
