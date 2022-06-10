class ParticipantsController < ApplicationController
  include Drivers::Email
  before_action :set_participant, only: %i[ show edit update destroy ]

  # GET /participants or /participants.json
  def index
    require_user_logged_in!
    @participants = Participant.all.order(created_at: :desc)
  end

  # GET /participants/1 or /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants or /participants.json
  def create
    @participant = Participant.new(participant_params)

    return error_ticket unless validates_ticket

    respond_to do |format|
      if @participant.save
        generate_tickets(@participant)
        format.html { redirect_to guest_path(@participant), notice: "Participant was successfully created." }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { redirect_to root_path, notice:  'Failed to register, please check the details and try again.' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1 or /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to participant_url(@participant), notice: "Participant was successfully updated." }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1 or /participants/1.json
  def destroy
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to participants_url, notice: "Participant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def validates_ticket
    adult_tickets = ticket_params[:adult_ticket].to_i
    children_tickets = ticket_params[:children_ticket].to_i

    adult_tickets.positive? || children_tickets.positive?
  end

  def error_ticket
    redirect_to root_url, notice: "Please select at least one ticket"
  end

  def generate_tickets(participant)
    adult_tickets = ticket_params[:adult_ticket].to_i
    if adult_tickets.present? && adult_tickets.positive?
      adult_tickets.times do
        ticket_number = SecureRandom.uuid
        Ticket.create!(participant: participant, ticket_number: ticket_number, age_group: 1)
      end
    end

    children_tickets = ticket_params[:children_ticket].to_i
    if children_tickets.present? && children_tickets.positive?
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
