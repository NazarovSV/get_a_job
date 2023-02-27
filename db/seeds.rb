# frozen_string_literal: true

unless Category.any?
  Category.create!(name: 'Full')
  Category.create!(name: 'Part-time')
  Category.create!(name: 'Shift')
  Category.create!(name: 'Remote')
  Category.create!(name: 'Rotational')
end
