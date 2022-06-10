class AttendanceController < ApplicationController

  def add_attendance
    ticket_number = params[:ticket_number]
    ticket = Ticket.find_by(ticket_number: ticket_number)
    if ticket.present?
      if Attendance.find_by(ticket: ticket).present?
        redirect_to qr_code_path(params[:qr_code_id]), alert: 'This Ticket is already used for the enterance.'
      else
        Attendance.create!(ticket: ticket, status: :entered, entry_time: Time.now)
        redirect_to qr_code_path(params[:qr_code_id]), notice: "Scan success! Enjoy the event."
      end
    else
      redirect_to qr_code_path(params[:qr_code_id]), alert: 'Invalid Ticket'
    end
  end

end
