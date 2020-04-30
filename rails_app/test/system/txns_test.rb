require "application_system_test_case"

class TxnsTest < ApplicationSystemTestCase
  setup do
    @txn = txns(:one)
  end

  test "visiting the index" do
    visit txns_url
    assert_selector "h1", text: "Txns"
  end

  test "creating a Txn" do
    visit txns_url
    click_on "New Txn"

    fill_in "Amt", with: @txn.amt
    fill_in "Dst bank", with: @txn.dst_bank_id
    fill_in "Src bank", with: @txn.src_bank_id
    fill_in "Txn status", with: @txn.txn_status_id
    fill_in "Txn type", with: @txn.txn_type_id
    fill_in "User", with: @txn.user_id
    click_on "Create Txn"

    assert_text "Txn was successfully created"
    click_on "Back"
  end

  test "updating a Txn" do
    visit txns_url
    click_on "Edit", match: :first

    fill_in "Amt", with: @txn.amt
    fill_in "Dst bank", with: @txn.dst_bank_id
    fill_in "Src bank", with: @txn.src_bank_id
    fill_in "Txn status", with: @txn.txn_status_id
    fill_in "Txn type", with: @txn.txn_type_id
    fill_in "User", with: @txn.user_id
    click_on "Update Txn"

    assert_text "Txn was successfully updated"
    click_on "Back"
  end

  test "destroying a Txn" do
    visit txns_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Txn was successfully destroyed"
  end
end
