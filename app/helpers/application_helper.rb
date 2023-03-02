# frozen_string_literal: true

module ApplicationHelper
  def flash_message(type)
    return unless flash[type]

    content_tag :div, class: "alert #{message_type(type.to_sym)} alert-dismissible fade show", role: 'alert' do
      content_tag(:span, flash[type]) +
        button_tag('', type: 'button', class: 'btn-close', data: { bs_dismiss: 'alert' }, aria: { label: 'Close' })
    end
  end

  def vacancy_state(state:)
    color = VACANCY_STATE[state.to_sym]

    content_tag :span, t(".#{state}"), class: color
  end

  def vacancy_salary_range(vacancy)
    if vacancy.salary_min.present? && vacancy.salary_max.present?
      "#{vacancy.salary_min} - #{vacancy.salary_max} #{vacancy.currency.name}"
    elsif vacancy.salary_min.present?
      I18n.t('.from_salary', salary: vacancy.salary_min, currency: vacancy.currency.name)
    elsif vacancy.salary_max.present?
      I18n.t('.to_salary', salary: vacancy.salary_max, currency: vacancy.currency.name)
    end
  end

  private

  MESSAGE_TYPE = {
    notice: 'alert-success',
    alert: 'alert-danger'
  }.freeze

  VACANCY_STATE = {
    drafted: 'text-secondary',
    published: 'text-danger',
    archived: 'text-info'
  }.freeze

  def message_type(type)
    MESSAGE_TYPE.key?(type) ? MESSAGE_TYPE[type] : 'alert-info'
  end
end
