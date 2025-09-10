ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def log_in_as(operator)
      session[:operator_id] = operator.id
    end
  end
end
