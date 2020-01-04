require 'rails_helper'

RSpec.feature "Homes", type: :feature do

  it "is expected to invert currency when clicked on button invert", js: true do
    visit(root_path)
    source_currency = find(id: "source_currency").value
    target_currency = find(id: "target_currency").value
    click_button id: "btn-reverse"
    new_source_currency = find(id: "source_currency").value
    new_target_currency = find(id: "target_currency").value
    expect(source_currency).to eq new_target_currency
    expect(target_currency).to eq new_source_currency
  end

end
