# frozen_string_literal: true

class ResponsePolicy < ApplicationPolicy
  def new?
    user.is_a? Employee
  end

  def create?
    user.is_a? Employee
  end
end
