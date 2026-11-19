require 'rails_helper'

RSpec.describe Hyrax::StatsController, type: :controller do
  routes { Hyrax::Engine.routes }

  let(:user) { create(:user) }
  let(:work) { create(:generic_work, user: user) }

  before do
    allow_any_instance_of(User).to receive(:groups).and_return([])
    sign_in user
    request.env['HTTP_REFERER'] = 'http://test.host/foo'
  end

  describe 'GET #work' do
    it 'renders the stats page when analytics reporting is unavailable' do
      allow(Hyrax::Analytics)
        .to receive(:daily_events_for_id)
        .and_raise(StandardError, 'analytics unavailable')

      get :work, params: { id: work }

      expect(response).to be_successful
      expect(response).to render_template('stats/work')
    end
  end
end
