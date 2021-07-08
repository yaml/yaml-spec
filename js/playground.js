(function() {
  window.PlayGround = (function() {
    function PlayGround() {}

    PlayGround.ref_parser_events = function(text) {
      var parser;
      parser = new Parser(new TestReceiver);
      parser.parse(text);
      return parser.receiver.output();
    };

    PlayGround.eemeli_loader_json = function(text) {
      return EYAML.parse(text);
    };

    PlayGround.yamlpp_parse_events = function(text) {
      return this.localhost_server(text, 'cmd=yamlpp&fmt=json');
    };

    PlayGround.fytool_parse_events = function(text) {
      return this.localhost_server(text, 'cmd=fytool&fmt=json');
    };

    PlayGround.localhost_server = function(text, args) {
      var data, e, env, loc, port, resp, scheme;
      loc = window.location.href.replace(/#$/, '');
      if (window.location.href.match(/^https/)) {
        scheme = 'https';
        port = 31337;
        env = 1;
      } else {
        scheme = 'http';
        port = 1337;
        env = 0;
      }
      try {
        resp = $.ajax({
          type: 'POST',
          url: scheme + "://0.0.0.0:" + port + "/?" + args,
          data: {
            text: text
          },
          dataType: 'json',
          async: false
        });
      } catch (error) {
        e = error;
        throw 'Try: docker run -it --rm -p 31337:8000 yamlio/...';
      }
      if (resp.status === 200) {
        data = resp.responseJSON;
        if (data != null) {
          if (data.error != null) {
            throw data.error;
          }
          if (data.output != null) {
            return data.output;
          }
        }
      }
      console.dir(resp);
      return "This pane requires a localhost sandbox server.\nSimply run:\n\n$ docker run --rm \\\n    --net host \\\n    -p " + port + ":" + port + " \\\n    -e HTTPS=" + env + " \\\n    yamlio/playground-sandbox:0.0.1\n\non the same computer as your web browser.\n\nAnd start a Chrome browser like this:\n\n$ <google-chrome> \\\n    --ignore-certificate-errors \\\n    --ignore-urlfetcher-cert-requests \\\n    --new-window \\\n    " + loc;
    };

    return PlayGround;

  })();

}).call(this);
