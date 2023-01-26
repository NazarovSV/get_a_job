# frozen_string_literal: true

module Hire
  class VacancyPolicy < ApplicationPolicy
    def show?
      user&.id == record.employer_id
    end

    def update?
      user&.id == record.employer_id
    end

    def new?
      user&.is_a? Employer
    end

    def publish?
      user&.id == record.employer_id
    end

    def archive?
      user&.id == record.employer_id
    end

    def create?
      user.is_a? Employer
    end

    def destroy?
      user&.id == record.employer_id
    end

    def list_of_response?
      show?
    end

    class Scope < Scope
      def resolve
        raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless user.is_a? Employer

        scope.where(employer: user)
      end
    end
  end
end
