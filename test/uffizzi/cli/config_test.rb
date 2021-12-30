# frozen_string_literal: true

require 'test_helper'
require 'uffizzi'

class ConfigTest < Minitest::Test
  def setup
    @config = Uffizzi::CLI::Config.new

    sign_in
  end

  def test_list
    result = @config.list

    assert_equal(result[:account_id], @account_id)
    assert_equal(result[:cookie], @cookie)
    assert_equal(result[:hostname], Uffizzi.configuration.hostname)
  end

  def test_get_with_property
    @config.get('cookie')

    assert_equal(Uffizzi::ConfigFile.read_option(:cookie), Uffizzi.ui.last_message)
    assert_equal(Uffizzi::ConfigFile.read_option(:cookie), result)
  end

  def test_get_with_wrong_property
    unexisted_property = 'unexisted_property'
    @config.get(unexisted_property)

    assert_equal("The option #{unexisted_property} doesn't exist in config file", Uffizzi.ui.last_message)
  end

  def test_set_with_property_and_value
    new_cookie = '_uffizzi=test2'

    refute_equal(Uffizzi::ConfigFile.read_option(:cookie), new_cookie)

    @config.set('cookie', new_cookie)

    assert_equal(Uffizzi::ConfigFile.read_option(:cookie), new_cookie)
  end

  def test_set_without_config
    cookie = '_uffizzi=test'

    Uffizzi::ConfigFile.delete

    @config.set('cookie', cookie)

    assert_equal(cookie, Uffizzi::ConfigFile.read_option(:cookie))
  end

  def test_delete_with_property
    @config.delete('cookie')

    refute(Uffizzi::ConfigFile.read_option(:cookie))
  end
end
