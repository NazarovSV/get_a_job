# frozen_string_literal: true

class SalaryForkValidator < ActiveModel::Validator
  def validate(record)
    return if fork_is_correct?(record)

    record.errors.add(:max_salary, I18n.t('.salary_fork_invalid'))
  end

  private

  def fork_is_correct?(record)
    record.salary_max.nil? || record.salary_min.nil? || record.salary_min < record.salary_max
  end
end
