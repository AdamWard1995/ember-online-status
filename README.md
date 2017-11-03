# ember-online-status

Ember addon for checking if Internet connection is up. Makes use of the [is-online](https://github.com/sindresorhus/is-online) module, polling to check if the Internet is accessible.

## Usage

- `ember install ember-online-status`
- Inject the service in either a controller, route, or component
- `onlineStatus.isCheckingConnection` returns `true` when checking the connection status, false otherwise.
- `onlineStatus.isOnline` returns `true` when the Internet is accessible, false otherwise.

Example:
```js
import Ember from 'ember';

export default Ember.Controller.extend({
  onlineStatus: Ember.inject.service()
});
```

```hbs
{{#if onlineStatus.isCheckingConnection}}
  Checking connection...
{{else}}
  {{#if onlineStatus.isOnline}}
    Online
  {{else}}
    Offline
  {{/if}}
{{/if}}
```

## Configuring

Can add a configuration in the `environment.js` file
```js
ENV.onlineStatus = {
  version: 'v4',
  pollInterval: 15000,
  timeout: 5000
};
```

##### pollInterval

Type: `number`
Default: `15000`

Milliseconds to wait before checking the connection status again.

##### timeout

Type: `number`
Default: `5000`

Milliseconds to wait for a server to respond.

##### version

Type: `string`
Values: `v4` `v6`
Default: `v4`

Internet Protocol version to use. This is an advanced option that is usually not necessary to be set, but it can prove useful to specifically assert IPv6 connectivity.

## Installation

* `git clone https://github.com/AdamWard1995/ember-online-status.git`
* `cd ember-online-status`
* `npm install`

## Try yourself

* `ember serve`
* Visit the dummy app at [http://localhost:4200](http://localhost:4200).
