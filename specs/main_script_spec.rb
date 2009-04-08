require 'app/rat_catcher_app'

describe 'main script' do

  it 'should create a RatCatcherApp' do
    mock_rat_catcher_app= mock(RatCatcherApp)
    RatCatcherApp.should_receive(:new).and_return(mock_rat_catcher_app)
    mock_rat_catcher_app.should_receive(:args)
    mock_rat_catcher_app.should_receive(:run)
    mock_rat_catcher_app.should_receive(:save)
    load('app/ratcatcher')
  end

end
