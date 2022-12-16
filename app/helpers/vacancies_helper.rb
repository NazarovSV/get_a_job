# frozen_string_literal: true

module VacanciesHelper
  def cut_paragraph(text:, length: 250)
    return if length <= 0

    "#{text[0..length]}..."
  end
end
