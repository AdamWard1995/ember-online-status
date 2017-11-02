import Ember from 'ember';
import _isOnline from 'npm:is-online';

export default Ember.Service.extend({
  config: Ember.inject.service(),
  isOnline: false,
  isCheckingConnection: true,
  timeout: Ember.computed.alias('config.onlineStatus.timeout'),
  version: Ember.computed.alias('config.onlineStatus.version'),
  interval: Ember.computed.alias('config.onlineStatus.pollInterval'),
  setup: Ember.on('init', function () {
    const connectionStatus = () => {
      this.set('isCheckingConnection', true);
      const params = {
        timeout: this.get('timeout') || 5000,
        version: this.get('version') || 'v4'
      };

      _isOnline(params).then((online) => {
        this.set('isOnline', online);
        this.set('isCheckingConnection', false);

        Ember.run.later(this, function () {
          connectionStatus()
        }, this.get('interval') || 15000);
      });
    };
    connectionStatus();

    window.addEventListener('offline', () => {
      this.set('isOnline', false);
    });
  })
});
