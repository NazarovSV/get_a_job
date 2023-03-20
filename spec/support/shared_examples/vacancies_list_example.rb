# frozen_string_literal: true

#TODO разделить
RSpec.shared_examples 'vacancies list' do
  include_examples 'currency list'

  before :all do
    Category.delete_all
    Experience.delete_all

    @category = create_list(:category, 3)
    @experience = create_list(:experience, 3)
    @ruby_dev = create(:vacancy,
                       :published,
                       :without_salary,
                       title: 'Ruby developer',
                       description: 'Ruby developer',
                       category: @category.second,
                       currency: @rub,
                       experience: @experience.first,
                       address: 'Ukraine, Kyiv')
    @js_dev = create(:vacancy,
                       :published,
                       salary_min: 10_000,
                       salary_max: 20_000,
                       title: 'JS developer',
                       description: 'JS developer',
                       category: @category.first,
                       currency: @rub,
                       experience: @experience.first,
                       address: 'Ukraine, Kyiv')
    @c_sharp_dev = create(:vacancy,
                       :published,
                       salary_min: 15_000,
                       salary_max: nil,
                       title: 'c# developer',
                       description: 'c# developer',
                       category: @category.first,
                       currency: @usd,
                       experience: @experience.last,
                       address: 'UK, London')
    @c_plus_dev = create(:vacancy,
                       :published,
                       salary_min: 4_500,
                       salary_max: 5_000,
                       title: 'c++ developer',
                       description: 'c++ developer',
                       category: @category.first,
                       currency: @usd,
                       experience: @experience.second,
                       address: 'Russia, Moscow')
    @go_dev = create(:vacancy,
                       :published,
                       salary_min: nil,
                       salary_max: 16_000,
                       title: 'Go developer',
                       description: 'Go developer',
                       category: @category.first,
                       currency: @rub,
                       experience: @experience.second,
                       address: 'Russia, Moscow')
    @java_dev = create(:vacancy,
                       salary_min: nil,
                       salary_max: 16_000,
                       title: 'Java developer',
                       description: 'Java developer',
                       category: @category.first,
                       currency: @rub,
                       experience: @experience.second,
                       address: 'Russia, Moscow')
  end
end


