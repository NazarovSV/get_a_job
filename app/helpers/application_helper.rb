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
