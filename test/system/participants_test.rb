require "application_system_test_case"

class ParticipantsTest < ApplicationSystemTestCase
  setup do
    @participant = participants(:one)
  end

  test "visiting the index" do
    visit participants_url
    assert_selector "h1", text: "Participants"
  end

  test "creating a Participant" do
    visit participants_url
    click_on "New Participant"

    fill_in "E transfer number", with: @participant.e_transfer_number
    fill_in "Email", with: @participant.email
    fill_in "Full name", with: @participant.full_name
    fill_in "Phone no", with: @participant.phone_no
    fill_in "Status", with: @participant.status
    click_on "Create Participant"

    assert_text "Participant was successfully created"
    click_on "Back"
  end

  test "updating a Participant" do
    visit participants_url
    click_on "Edit", match: :first

    fill_in "E transfer number", with: @participant.e_transfer_number
    fill_in "Email", with: @participant.email
    fill_in "Full name", with: @participant.full_name
    fill_in "Phone no", with: @participant.phone_no
    fill_in "Status", with: @participant.status
    click_on "Update Participant"

    assert_text "Participant was successfully updated"
    click_on "Back"
  end

  test "destroying a Participant" do
    visit participants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Participant was successfully destroyed"
  end
end
