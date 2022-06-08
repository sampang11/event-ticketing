class GuestsController < ApplicationController

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # POST /participants or /participants.json
  def create
    @participant = Participant.new(participant_params)

    respond_to do |format|
      if @participant.save
        generate_tickets(@participant)
        format.html { redirect_to guest_url(@participant), notice: "Participant was successfully created." }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @participant = Participant.find(params[:id])
  end

  private

  def generate_tickets(participant)
    adult_tickets = ticket_params[:adult_ticket].to_i
    if adult_tickets.present? && adult_tickets > 1
      adult_tickets.times do
        ticket_number = SecureRandom.uuid
        Ticket.create!(participant: participant, ticket_number: ticket_number, age_group: 1)
      end
    end

    children_tickets = ticket_params[:children_ticket].to_i
    if children_tickets.present? && children_tickets > 1
      children_tickets.times do
        ticket_number = SecureRandom.uuid
        Ticket.create!(participant: participant, ticket_number: ticket_number, age_group: 0)
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    @participant = Participant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def participant_params
    params.require(:participant).permit(:full_name, :email, :phone_no, :e_transfer_number, :status, :address)
  end

  def ticket_params
    params.require(:participant).permit(:adult_ticket, :children_ticket)
  end
end
