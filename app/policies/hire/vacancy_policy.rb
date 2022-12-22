# frozen_string_literal: true

module Hire
  class VacancyPolicy < ApplicationPolicy
    def show?
      user == record.employer
    end

    def update?
      user == record.employer
    end

    class Scope < Scope
      # NOTE: Be explicit about which records you allow access to!
      # def resolve
      #   scope.all
      # end
    end
  end
end
