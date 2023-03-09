# frozen_string_literal: true

require 'rails_helper'

describe 'Only authenticated user as employer can add new vacancy', '
  to find a new employee
  user can register as hire
  and create a new vacancy
' do
  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:currencies) { create_list(:currency, 3) }
    let!(:categories) { create_list(:category, 5) }
    let(:vacancy) { build(:vacancy, employer:) }
    let(:location) { build(:location, vacancy: create(:vacancy)) }

    before do
      sign_in_employer(employer)
      click_on 'New'
    end

    it 'can add new vacancy with all filled fields' do
      fill_in 'Title', with: vacancy.title
      select categories.second.name, from: 'vacancy[category_id]'
      fill_in 'Description', with: vacancy.description
      fill_in 'Phone', with: vacancy.phone
      fill_in 'Email', with: vacancy.email
      fill_in 'Address', with: location.address
      fill_in 'Salary From', with: vacancy.salary_min
      fill_in 'Salary To', with: vacancy.salary_max
      select currencies.first.name, from: 'vacancy[currency_id]'

      click_on 'Create'

      expect(page).to have_content('Your vacancy successfully created.')
                  .and have_content(vacancy.title)
                  .and have_content(vacancy.description)
                  .and have_content(vacancy.phone)
                  .and have_content(vacancy.email)
                  .and have_content(location.address)
                  .and have_content(categories.second.name)
                  .and have_content(vacancy.salary_min)
                  .and have_content(vacancy.salary_max)
                  .and have_content(currencies.first.name)
    end

    it 'can add new vacancy without phone' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email
      fill_in 'Address', with: vacancy.location.address
      select categories.second.name, from: 'vacancy[category_id]'
      fill_in 'Salary From', with: vacancy.salary_min
      fill_in 'Salary To', with: vacancy.salary_max
      select currencies.first.name, from: 'vacancy[currency_id]'

      click_on 'Create'

      expect(page).to have_content 'Your vacancy successfully created.'

      expect(page).to have_content vacancy.title
      expect(page).to have_content vacancy.description
      expect(page).to have_content vacancy.email
    end

    it 'can`t add new vacancy without title' do
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end

    it 'can`t add new vacancy without address' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Phone', with: vacancy.phone
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "address can't be blank"
    end

    it 'can`t add new vacancy with invalid address' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Phone', with: vacancy.phone
      fill_in 'Email', with: vacancy.email
      fill_in 'Address', with: 'some address'

      click_on 'Create'

      expect(page).to have_content 'Location address is invalid'
    end

    it 'can`t add new vacancy without description' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Email', with: vacancy.email

      click_on 'Create'

      expect(page).to have_content "Description can't be blank"
    end

    it 'can`t add new vacancy without email' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description

      click_on 'Create'

      expect(page).to have_content "Email can't be blank"
    end

    it 'can use autocomplete in address field', js: true do
      create(:vacancy)

      fill_in 'Address', with: 'Mos'
      find('.easy-autocomplete-container li', text: 'Russia, Moscow, Klimentovskiy Pereulok, 65').click

      expect(page).to have_content 'Russia, Moscow, Klimentovskiy Pereulok, 65'
    end
  end

  describe 'User can convert currency while inputting', js: true do
    let!(:exchange_service) { double('ExchangeRatesService') }
    let!(:employer) { create(:employer) }
    let!(:usd) { create(:currency, name: 'USD', code: :USD) }
    let!(:eur) { create(:currency, name: 'EUR', code: :EUR) }
    let!(:gbp) { create(:currency, name: 'GBP', code: :GBP) }

    before do
      returned_json = [{ amount: 80, currency: 'EUR' }, { amount: 70, currency: 'GBP' }]
      second_returned_json = [{ amount: 800, currency: 'EUR' }, { amount: 700, currency: 'GBP' }]
      allow(ExchangeRatesService).to receive(:new).and_return(exchange_service)
      allow(exchange_service).to receive(:call).with(from: usd, amount: 100).and_return(returned_json)
      allow(exchange_service).to receive(:call).with(from: usd, amount: 1000).and_return(second_returned_json)

      sign_in_employer(employer)
      click_on 'New'
    end

    it 'convert if min salary equal or greater then 100' do
      fill_in 'Salary From', with: 100
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      fill_in 'Salary From', with: 1000
      expect(page).to have_content '800 EUR'
      expect(page).to have_content '700 GBP'
    end

    it 'convert if max salary equal or greater then 100' do
      fill_in 'Salary To', with: 100
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      fill_in 'Salary To', with: 1000
      expect(page).to have_content '800 EUR'
      expect(page).to have_content '700 GBP'
    end

    it 'no effect if min salary lesser then 100' do
      fill_in 'Salary From', with: 90

      within '.salary_min_converted', visible: false do
        expect(page.text).to be_empty
      end
    end

    it 'no effect if max salary lesser then 100' do
      fill_in 'Salary To', with: 90

      within '.salary_max_converted', visible: false do
        expect(page.text).to be_empty
      end
    end
  end

  describe 'Unathenticated user' do
    it 'can`t access to creating vacancy path' do
      visit new_hire_vacancy_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
