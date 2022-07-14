class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create

    return same_team_error if game_params['team_one_id'] == game_params['team_two_id']

    return invalid_game if game_params['game_number'].to_i > 15

    new_params = { team_one_id: Team.find(game_params['team_one_id']),
                   team_two_id: Team.find(game_params['team_two_id']),
                   team_one_score: game_params['team_one_score'],
                   team_two_score: game_params['team_two_score'],
                   competition_id: game_params['competition_id'],
                   game_number: game_params['game_number'] }

    @game = Game.new(new_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def same_team_error
    redirect_to new_game_url, alert: "Please select different teams"
  end

  def invalid_game
    redirect_to games_url, alert: "No more games can be played this game week"
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      new_params = { team_one_id: Team.find(game_params['team_one_id']),
                     team_two_id: Team.find(game_params['team_two_id']),
                     team_one_score: game_params['team_one_score'],
                     team_two_score: game_params['team_two_score'],
                     competition_id: game_params['competition_id'],
                     game_number: game_params['game_number'] }

      if @game.update(new_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:team_one_id, :team_two_id, :team_one_score, :team_two_score, :competition_id, :game_number)
  end
end
