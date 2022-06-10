class QrCodesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_qr_data, only: :create

  def index
    @qr_codes = QrCode.order(created_at: :desc).first(20)
  end

  def new
  end

  def create
    ticket_number = @qr_data
    ticket = Ticket.find_by(ticket_number: ticket_number)
    if ticket.present?
      if Attendance.find_by(ticket: ticket).present?
        redirect_to basic_qr_code_reader_path, alert: 'This Ticket is already used for the enterance.'
      else
        qr_code = QrCode.create(data: @qr_data)
        Attendance.create!(ticket: ticket, status: :entered, entry_time: Time.now)
        redirect_to qr_code_path(qr_code), notice: "Scan success! Enjoy the event."
      end
    else
      redirect_to basic_qr_code_reader_path, alert: 'Invalid Ticket'
    end
  end

  def show
    @qr_code = QrCode.find(params[:id])
    @ticket = Ticket.find_by(ticket_number: @qr_code.data)
  end

  private

  def set_qr_data
    qr_code_params = JSON.parse(params[:qr_code_json_data]).with_indifferent_access

    @qr_data = qr_code_params[:qr_data]
  end
end