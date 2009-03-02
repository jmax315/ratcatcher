require 'app/ratcatcher_app'

describe 'main script' do

  it 'should create a RatcatcherApp' do
    mock_ratcatcher_app= mock(RatcatcherApp)
    RatcatcherApp.should_receive(:new).and_return(mock_ratcatcher_app)
    mock_ratcatcher_app.should_receive(:run)
    load('app/ratcatcher')
  end

end
