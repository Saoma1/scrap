require "application_system_test_case"

class TorrentsTest < ApplicationSystemTestCase
  setup do
    @torrent = torrents(:one)
  end

  test "visiting the index" do
    visit torrents_url
    assert_selector "h1", text: "Torrents"
  end

  test "creating a Torrent" do
    visit torrents_url
    click_on "New Torrent"

    fill_in "Main", with: @torrent.main
    fill_in "Release year", with: @torrent.release_year
    fill_in "Title", with: @torrent.title
    fill_in "Url", with: @torrent.url
    click_on "Create Torrent"

    assert_text "Torrent was successfully created"
    click_on "Back"
  end

  test "updating a Torrent" do
    visit torrents_url
    click_on "Edit", match: :first

    fill_in "Main", with: @torrent.main
    fill_in "Release year", with: @torrent.release_year
    fill_in "Title", with: @torrent.title
    fill_in "Url", with: @torrent.url
    click_on "Update Torrent"

    assert_text "Torrent was successfully updated"
    click_on "Back"
  end

  test "destroying a Torrent" do
    visit torrents_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Torrent was successfully destroyed"
  end
end
