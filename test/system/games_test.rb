require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  setup do
    @game = games(:one)
  end

  test "visiting the index" do
    visit games_url
    assert_selector "h1", text: "Games"
  end

  test "creating a Game" do
    visit games_url
    click_on "New Game"

    fill_in "Game number", with: @game.game_number
    fill_in "Game week", with: @game.game_week
    fill_in "Team one", with: @game.team_one
    fill_in "Team one score", with: @game.team_one_score
    fill_in "Team two", with: @game.team_two
    fill_in "Team two score", with: @game.team_two_score
    click_on "Create Game"

    assert_text "Game was successfully created"
    click_on "Back"
  end

  test "updating a Game" do
    visit games_url
    click_on "Edit", match: :first

    fill_in "Game number", with: @game.game_number
    fill_in "Game week", with: @game.game_week
    fill_in "Team one", with: @game.team_one
    fill_in "Team one score", with: @game.team_one_score
    fill_in "Team two", with: @game.team_two
    fill_in "Team two score", with: @game.team_two_score
    click_on "Update Game"

    assert_text "Game was successfully updated"
    click_on "Back"
  end

  test "destroying a Game" do
    visit games_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game was successfully destroyed"
  end
end
