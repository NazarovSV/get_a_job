# frozen_string_literal: true

RSpec.shared_context 'Vacancies' do
  include_context 'Currency'

  before do
    Employment.delete_all
    Experience.delete_all
    Specialization.delete_all

    @employment = create_list(:employment, 3)
    @experience = create_list(:experience, 3)
    @specializations = create_list(:specialization, 2)

    @ruby_dev = create(:vacancy,
                       :published,
                       :without_salary,
                       title: 'Ruby developer',
                       description: 'Ruby developer',
                       employment: @employment.second,
                       currency: @rub,
                       experience: @experience.first,
                       address: 'Ukraine, Kyiv',
                       skip_fill_usd_salaries: false,
                       specialization: @specializations.first)
    @js_dev = create(:vacancy,
                     :published,
                     salary_min: 10_000,
                     salary_max: 20_000,
                     title: 'JS developer',
                     description: 'JS developer',
                     employment: @employment.first,
                     currency: @rub,
                     experience: @experience.first,
                     address: 'Ukraine, Kyiv',
                     skip_fill_usd_salaries: false,
                     specialization: @specializations.first)
    @c_sharp_dev = create(:vacancy,
                          :published,
                          salary_min: 15_000,
                          salary_max: nil,
                          title: 'c# developer',
                          description: 'c# developer',
                          employment: @employment.first,
                          currency: @usd,
                          experience: @experience.last,
                          address: 'UK, London',
                          skip_fill_usd_salaries: false,
                          specialization: @specializations.first)
    @c_plus_dev = create(:vacancy,
                         :published,
                         salary_min: 4_500,
                         salary_max: 5_000,
                         title: 'c++ developer',
                         description: 'c++ developer',
                         employment: @employment.first,
                         currency: @usd,
                         experience: @experience.second,
                         address: 'Russia, Moscow',
                         skip_fill_usd_salaries: false,
                         specialization: @specializations.second)
    @go_dev = create(:vacancy,
                     :published,
                     salary_min: nil,
                     salary_max: 16_000,
                     title: 'Go developer',
                     description: 'Go developer',
                     employment: @employment.first,
                     currency: @rub,
                     experience: @experience.first,
                     address: 'Russia, Moscow',
                     skip_fill_usd_salaries: false,
                     specialization: @specializations.second)
    @java_dev = create(:vacancy,
                       salary_min: nil,
                       salary_max: 16_000,
                       title: 'Java developer',
                       description: 'Java developer',
                       employment: @employment.first,
                       currency: @rub,
                       experience: @experience.second,
                       address: 'Russia, Moscow',
                       skip_fill_usd_salaries: false,
                       specialization: @specializations.second)
  end
end
