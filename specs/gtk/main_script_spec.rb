require 'app/rat_catcher_app'

describe 'main script' do

  it 'should create a RatCatcherApp' do
    mock_rat_catcher_app= mock(RatCatcherApp)
    RatCatcherApp.should_receive(:new).and_return(mock_rat_catcher_app)

    Object.send(:remove_const, :ARGV)
    ARGV= ['fake_app_arg']

    mock_rat_catcher_app.should_receive(:args).with(['fake_app_arg'])
    mock_rat_catcher_app.should_receive(:run)
    load('app/ratcatcher')
  end

end
