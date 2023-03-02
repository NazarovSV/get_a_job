# frozen_string_literal: true

def create_category_with_translate(en_name:, ru_name:)
  category = Category.new(name: en_name)
  category.name_translations = { en: en_name, ru: ru_name }
  category.save!
end

unless Category.any?
  create_category_with_translate(en_name: 'Full', ru_name: 'Полный')
  create_category_with_translate(en_name: 'Partial', ru_name: 'Частичный')
  create_category_with_translate(en_name: 'Shift', ru_name: 'Сменный')
  create_category_with_translate(en_name: 'Remote', ru_name: 'Удаленный')
  create_category_with_translate(en_name: 'Rotational', ru_name: 'Вахтовый')
end

unless Currency.any?
  Currency.create(name: 'Руб', code: 'RUB')
  Currency.create(name: 'USD', code: 'USD')
  Currency.create(name: 'EURO', code: 'EUR')
end
