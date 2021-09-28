---
---
class window.Playground
  @init: (eatme) ->
    params = new URLSearchParams(window.location.search)
    if params.has('input')
      base64 = params.get('input')
        .replace(/-/g, '+')
        .replace(/_/g, '/')
      try
        eatme.input = decodeURIComponent(escape(atob(base64)))
      catch e
        console.log(base64)
        console.log(e)

  @change: (text, pane)->
    {origin, pathname} = window.location
    base64 = btoa(unescape(encodeURIComponent(text)))
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
    newurl = "#{origin}#{pathname}?input=#{base64}"
    window.history.replaceState(null, null, newurl)

  @js_refparser_event: (text)->
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

  @hs_refparser_yeast: (text)->
    value = @localhost_server(text, 'cmd=hs-reference-yeast')
    if _.isString(value) and value.match(/\ =(?:ERR\ |REST)\|/)
      throw value
    else
      return value

  @yamlpp_event: (text)->
    return @sandbox_event(text, 'cmd=perl-pp-event')

  @npmyaml_event: (text)->
    return @sandbox_event(text, 'cmd=js-yaml-event')

  @pyyaml_event: (text)->
    return @sandbox_event(text, 'cmd=py-pyyaml-event')

  @libfyaml_event: (text)->
    return @sandbox_event(text, 'cmd=c-libfyaml-event')

  @libyaml_event: (text)->
    return @sandbox_event(text, 'cmd=c-libfyaml-event')

  @yamlcpp_event: (text)->
    return @sandbox_event(text, 'cmd=cpp-yamlcpp-event')

  @nimyaml_event: (text)->
    return @sandbox_event(text, 'cmd=nim-nimyaml-event')

  @hsyaml_event: (text)->
    return @sandbox_event(text, 'cmd=hs-hsyaml-event')

  @snakeyaml_event: (text)->
    return @sandbox_event(text, 'cmd=java-snakeyaml-event')

  @yamldotnet_event: (text)->
    return @sandbox_event(text, 'cmd=dotnet-yamldotnet-event')

  @ruamel_event: (text)->
    return @sandbox_event(text, 'cmd=py-ruamel-event')

  @sandbox_event: (text, args)->
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
      throw 'Try: docker run --rm -d -p 31337:8000 yamlio/...'

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

      Run:

      ```
      $ docker run --rm -d -p #{port}:#{port} \\
          yamlio/playground-sandbox:0.0.5 #{scheme}
      ```


      on the same computer as your web browser.

      See #{help}  
      for more instructions.
      """
