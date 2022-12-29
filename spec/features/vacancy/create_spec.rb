# frozen_string_literal: true

require 'rails_helper'

describe 'Only authenticated user as hire can add new vacancy', '
  to find a new employee
  user can register as hire
  and create a new vacancy
' do
  describe 'Unathenticated user' do
    it 'can`t access to creating vacancy path' do
      visit new_hire_vacancy_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
