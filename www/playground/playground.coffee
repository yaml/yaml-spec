class window.Playground
  @refparser_events: (text)->
    parser = new Parser(new TestReceiver)
    parser.parse(text)
    return parser.receiver.output()

  @npmyamlmaster_json: (text)->
    data = npmYAML.parse(text)
    return JSON.stringify(data, null, 2)

  @npmyamlmaster_event: (text)->
      {events, error} = npmYAML.events(text)
      throw error if error?
      return events.join("\n")

  @npmyaml1_json: (text)->
    data = npmYAML1.parse(text)
    return JSON.stringify(data, null, 2)

  @npmyaml1_event: (text)->
      {events, error} = npmYAML1.events(text)
      throw error if error?
      return events.join("\n")

  @npmyaml2_json: (text)->
    data = npmYAML2.parse(text)
    return JSON.stringify(data, null, 2)

  @npmyaml2_event: (text)->
      {events, error} = npmYAML2.events(text)
      throw error if error?
      return events.join("\n")

  @npmjsyaml_json: (text)->
    data = npmJSYAML.load(text)
    return JSON.stringify(data, null, 2)

  @yamlpp_events: (text)->
    return @sandbox_events(text, 'cmd=perl-pp-event')

  @npmyaml_events: (text)->
    return @sandbox_events(text, 'cmd=js-yaml-event')

  @pyyaml_events: (text)->
    return @sandbox_events(text, 'cmd=py-pyyaml-event')

  @libfyaml_events: (text)->
    return @sandbox_events(text, 'cmd=c-libfyaml-event')

  @libyaml_events: (text)->
    return @sandbox_events(text, 'cmd=c-libyaml-event')

  @sandbox_events: (text, args)->
    value = @localhost_server(text, args)
    if _.isString(value) and value.match(/^[^\+\-\=]/m)
      throw value
    else
      return value

  @localhost_server: (text, args)->
    loc = window.location.href
      .replace(/#$/, '')

    if window.location.href.match(/^https/)
      scheme = 'https'
      port = 31337
    else
      scheme = 'http'
      port = 1337

    try
      resp = $.ajax(
        type: 'POST'
        url: "#{scheme}://localhost:#{port}/?#{args}"
        data: { text: text }
        dataType: 'json'
        async: false
        # success: (a...)=> @localhost_success()
        # error: (a...)=> @localhost_success()
      )
    catch e
      throw 'Try: docker run -it --rm -p 31337:8000 yamlio/...'

    if resp.status == 200
      data = resp.responseJSON
      if data?
        if data.error?
          throw data.error
        if data.output?
          return data.output

    console.dir('Error calling localhost sandbox:')
    console.dir(resp)

    help = loc.replace(
      /(\/playground\/).*/,
      "$1#setting-up-a-local-sandbox",
    )

    return mark: """
      This pane requires a localhost sandbox server.

      Simply run:

      ```
      $ docker run --rm -p #{port}:#{port} \\
          yamlio/playground-sandbox:0.0.3 #{scheme}
      ```


      on the same computer as your web browser.

      See #{help}  
      for more instructions.
      """
