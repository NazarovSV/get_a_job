# frozen_string_literal: true

module Candidate
  class ResponsePolicy < ApplicationPolicy
    def show?
      user&.id == record.employee_id
    end

    def new?
      user.is_a? Employee
    end

    def create?
      user.is_a? Employee
    end

    class Scope < Scope
      def resolve
        raise Pundit::NotAuthorizedError, i18n.t('.not_allowed') unless user.is_a? Employee

        scope.where(employee: user)
      end
    end
  end
end
