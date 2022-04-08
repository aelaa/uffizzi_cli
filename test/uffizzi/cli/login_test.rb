# frozen_string_literal: true

require 'test_helper'

class LoginTest < Minitest::Test
  def setup
    @cli = Uffizzi::CLI.new

    @command_params = {
      user: generate(:email),
      password: generate(:string),
      server: Uffizzi.configuration.server,
    }

    @cli.options = { user: @command_params[:user], server: @command_params[:server] }
  end

  def test_login_success
    console_mock = mock('console_mock')
    console_mock.stubs(:getpass).returns(@command_params[:password])
    IO.stubs(:console).returns(console_mock)

    body = json_fixture('files/uffizzi/uffizzi_login_success.json')

    stubbed_uffizzi_login = stub_uffizzi_login_success(body)

    refute(Uffizzi::ConfigFile.exists?)

    @cli.login

    assert_requested(stubbed_uffizzi_login)
    assert(Uffizzi::ConfigFile.exists?)
  end

  def test_login_failed
    body = json_fixture('files/uffizzi/uffizzi_login_failed.json')
    stubbed_uffizzi_login = stub_uffizzi_login_failed(body)

    refute(Uffizzi::ConfigFile.exists?)

    @cli.login

    assert_requested(stubbed_uffizzi_login)
    refute(Uffizzi::ConfigFile.exists?)
  end
end
