# frozen_string_literal: true

module WaitForAjax
  def wait_for_ajax
    max_time = Capybara::Helpers.monotonic_time + Capybara.default_max_wait_time
    while Capybara::Helpers.monotonic_time < max_time
      finished = finished_all_ajax_requests?
      break if finished

      sleep 0.1

    end
    raise 'wait_for_ajax timeout' unless finished
  end

  private

  def finished_all_ajax_requests?
    page.evaluate_script(<<~EOS
      ((typeof window.jQuery === 'undefined')
       || (typeof window.jQuery.active === 'undefined')
       || (window.jQuery.active === 0))
      && ((typeof window.injectedJQueryFromNode === 'undefined')
       || (typeof window.injectedJQueryFromNode.active === 'undefined')
       || (window.injectedJQueryFromNode.active === 0))
      && ((typeof window.httpClients === 'undefined')
       || (window.httpClients.every(function (client) { return (client.activeRequestCount === 0); })))
    EOS
                        )
  end

  RSpec.configure do |config|
    config.include WaitForAjax, type: :feature
  end
end
