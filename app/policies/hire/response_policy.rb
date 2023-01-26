# frozen_string_literal: true

module Hire
  class ResponsePolicy < ApplicationPolicy
    def show?
      user&.id == record.vacancy.employer_id
    end
  end
end
