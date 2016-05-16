
# Wrapper for [https://github.com/pusher/pusher-js](Pusher JS)
# ---------------------------------------------------------------

angular
  .module('impac.services.pusher', [])
  .service('Pusher', ($window) ->

    _self = @

    @config =
      key: 'e98dfd8e4a359a7faf48'
      pusherOpts:
        encrypted: true

    @channels = []

    # Initializes an instance of Pusher, and subscribes to all given channels.
    #
    # @param channels [Array of Strings] Subscribe pusher client to channels
    # @return [Pusher] Chain onto class methods, e.g the `@bind` method.
    @init = (channels=[]) ->
      _self.instance = new $window.Pusher(_self.config.key, _self.config.pusherOpts)
      for channel in channels
        _self.channels.push(_self[channel] = _self.instance.subscribe(channel))
      return _self

    # Bind an event callback onto a new or existing channel.
    #
    # @param channel [String]
    # @param event [String]
    # @param callback [Function]
    @bind = (channel, event, callback) ->
      _self[channel] = _self.instance.subscribe(channel) unless _self[channel]
      _self[channel].bind(event, callback)

    # Bind an event callback to all available channels.
    #
    # @param event [String]
    # @param callback [Function]
    @bindAll = (event, callback) ->
      _.forEach(_self.channels, (chan) -> chan.bind(event, callback))

    return _self
  )
