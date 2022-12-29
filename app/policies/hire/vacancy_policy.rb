# frozen_string_literal: true

module Hire
  class VacancyPolicy < ApplicationPolicy
    def show?
      user == record.employer
    end

    def update?
      user == record.employer
    end

    def new?
      user.is_a? Employer
    end

    def create?
      user.is_a? Employer
    end

    class Scope < Scope
      def resolve
        raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless user.is_a? Employer

        scope.where(employer: user)
      end
    end
  end
end
