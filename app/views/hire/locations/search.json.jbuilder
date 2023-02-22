# frozen_string_literal: true

json.array!(@locations) do |address|
  json.name address
end
