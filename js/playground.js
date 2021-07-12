(function() {
  window.Playground = (function() {
    function Playground() {}

    Playground.refparser_events = function(text) {
      var parser;
      parser = new Parser(new TestReceiver);
      parser.parse(text);
      return parser.receiver.output();
    };

    Playground.npm_yaml_json = function(text) {
      var yaml;
      yaml = npmYAML.parse(text);
      return JSON.stringify(yaml, null, 2);
    };

    Playground.yamlpp_events = function(text) {
      return this.sandbox_events(text, 'cmd=perl-pp-event');
    };

    Playground.yamljs_events = function(text) {
      return this.sandbox_events(text, 'cmd=js-yaml-event');
    };

    Playground.pyyaml_events = function(text) {
      return this.sandbox_events(text, 'cmd=py-pyyaml-event');
    };

    Playground.libfyaml_events = function(text) {
      return this.sandbox_events(text, 'cmd=c-libfyaml-event');
    };

    Playground.libyaml_events = function(text) {
      return this.sandbox_events(text, 'cmd=c-libyaml-event');
    };

    Playground.sandbox_events = function(text, args) {
      var value;
      value = this.localhost_server(text, args);
      if (_.isString(value) && value.match(/^[^\+\-\=]/m)) {
        throw value;
      } else {
        return value;
      }
    };

    Playground.localhost_server = function(text, args) {
      var data, e, help, loc, port, resp, scheme;
      loc = window.location.href.replace(/#$/, '');
      if (window.location.href.match(/^https/)) {
        scheme = 'https';
        port = 31337;
      } else {
        scheme = 'http';
        port = 1337;
      }
      try {
        resp = $.ajax({
          type: 'POST',
          url: scheme + "://localhost:" + port + "/?" + args,
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
      console.dir('Error calling localhost sandbox:');
      console.dir(resp);
      help = loc.replace(/(\/playground\/).*/, "$1");
      return {
        mark: "This pane requires a localhost sandbox server.\n\nSimply run:\n\n```\n$ docker run --rm -p " + port + ":" + port + " \\\n    yamlio/playground-sandbox:0.0.3 " + scheme + "\n```\n\n\non the same computer as your web browser.\n\nSee " + help + "  \nfor more instructions."
      };
    };

    return Playground;

  })();

}).call(this);
