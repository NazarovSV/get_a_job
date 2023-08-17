# frozen_string_literal: true

require 'rails_helper'

describe 'Only authenticated user as employer can add new vacancy', '
  to find a new employee
  user can register as hire
  and create a new vacancy
' do
  include_context 'Currency'

  describe 'Authenticated user' do
    let!(:employer) { create(:employer) }
    let!(:employments) { create_list(:employment, 5) }
    let!(:experience) { create_list(:experience, 3) }
    let!(:specializations) { create_list(:specialization, 4) }
    let!(:vacancy) { build(:vacancy, currency: @rub, employer:, address: 'UK, London') }

    before do
      sign_in_employer(employer)
      click_on 'New'
    end

    it 'can add new vacancy with all filled fields' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email
      fill_in 'Phone', with: vacancy.phone
      fill_in 'Address', with: vacancy.location.address
      select employments.second.name, from: 'vacancy[employment_id]'
      fill_in 'Salary From', with: vacancy.salary_min
      fill_in 'Salary To', with: vacancy.salary_max
      select experience.first.description, from: 'vacancy[experience_id]'
      select specializations.second.name, from: 'vacancy[specialization_id]'
      select @rub.name, from: 'vacancy[currency_id]'

      click_on 'Create'

      expect(page).to have_content('Your vacancy successfully created.')
                  .and have_content(vacancy.title)
                  .and have_content(vacancy.description)
                  .and have_content(vacancy.phone)
                  .and have_content(vacancy.email)
                  .and have_content(vacancy.location.address)
                  .and have_content(employments.second.name)
                  .and have_content(vacancy.salary_min)
                  .and have_content(vacancy.salary_max)
                  .and have_content(@rub.name)
                  .and have_content(experience.first.description)
                  .and have_content(specializations.second.name)
    end

    it 'can add new vacancy without phone' do
      fill_in 'Title', with: vacancy.title
      fill_in 'Description', with: vacancy.description
      fill_in 'Email', with: vacancy.email
      fill_in 'Address', with: vacancy.location.address
      select employments.second.name, from: 'vacancy[employment_id]'
      fill_in 'Salary From', with: vacancy.salary_min
      fill_in 'Salary To', with: vacancy.salary_max
      select @rub.name, from: 'vacancy[currency_id]'
      select experience.first.description, from: 'vacancy[experience_id]'

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
      create(:location, address: 'Russia, Moscow, Klimentovskiy Pereulok, 65')

      fill_in 'Address', with: 'Mos'
      sleep 1
      find('.easy-autocomplete-container li', text: 'Russia, Moscow, Klimentovskiy Pereulok, 65').click

      expect(page).to have_content 'Russia, Moscow, Klimentovskiy Pereulok, 65'
    end
  end

  context 'User can convert currency while inputting', js: true do
    let!(:exchange_service) { double('ExchangeRatesService') }
    let!(:currency_converter) { double('CurrencyConverter') }
    let!(:employer) { create(:employer) }

    before do
      allow(ExchangeRatesService).to receive(:new).and_return(exchange_service)

      usd_returned_json = [{ amount: 80, currency: 'EUR' }, { amount: 70, currency: 'GBP' }]
      allow(exchange_service).to receive(:call).with(from: @usd, amount: 100).and_return(usd_returned_json)

      usd_second_returned_json = [{ amount: 800, currency: 'EUR' }, { amount: 700, currency: 'GBP' }]
      allow(exchange_service).to receive(:call).with(from: @usd, amount: 1000).and_return(usd_second_returned_json)

      allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
      allow(currency_converter).to receive(:convert).with(amount: 100, from: @usd, to: @eur).and_return(80)
      allow(currency_converter).to receive(:current_rate_to_usd).and_return(1)

      eur_returned_json = [{ amount: 100, currency: 'USD' }, { amount: 70, currency: 'GBP' }]
      allow(exchange_service).to receive(:call).with(from: @eur, amount: 80).and_return(eur_returned_json)

      sign_in_employer(employer)
      click_on 'New'
    end

    it 'convert if min salary equal or greater then 100', js: true do
      fill_in 'Salary From', with: 100
      find('#salary_min').native.send_keys(:enter)
      wait_for_ajax
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      fill_in 'Salary From', with: 1000
      find('#salary_min').native.send_keys(:enter)
      wait_for_ajax
      expect(page).to have_content '800 EUR'
      expect(page).to have_content '700 GBP'
    end

    it 'convert if max salary equal or greater then 100', js: true do
      fill_in 'Salary To', with: 100
      find('#salary_max').native.send_keys(:enter)
      wait_for_ajax
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      fill_in 'Salary To', with: 1000
      find('#salary_max').native.send_keys(:enter)
      wait_for_ajax
      expect(page).to have_content '800 EUR'
      expect(page).to have_content '700 GBP'
    end

    it 'save converted salary after failed creation', js: true do
      fill_in 'Salary To', with: 100
      find('#salary_max').native.send_keys(:enter)
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      click_on 'Create'

      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'
    end

    it 'convert amount if currency changed', js: true do
      select @usd.name, from: 'vacancy[currency_id]'

      fill_in 'Salary From', with: 100
      find('#salary_min').native.send_keys(:enter)
      expect(page).to have_content '80 EUR'
      expect(page).to have_content '70 GBP'

      select @eur.name, from: 'vacancy[currency_id]'

      expect(page).to have_content '100 USD'
      expect(page).to have_content '70 GBP'
      expect(page).to have_field('Salary From', with: 80)
    end
  end

  describe 'Unathenticated user' do
    it 'can`t access to creating vacancy path' do
      visit new_hire_vacancy_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
