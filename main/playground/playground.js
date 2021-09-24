(function() {
  window.Playground = (function() {
    function Playground() {}

    Playground.init = function(eatme) {
      var params;
      params = new URLSearchParams(window.location.search);
      if (params.has('input')) {
        try {
          return eatme.input = atob(params.get('input'));
        } catch (error1) {}
      }
    };

    Playground.change = function(text, pane) {
      var base64, newurl, origin, pathname, ref;
      ref = window.location, origin = ref.origin, pathname = ref.pathname;
      base64 = btoa(text);
      newurl = "" + origin + pathname + "?input=" + base64;
      return window.history.replaceState(null, null, newurl);
    };

    Playground.js_refparser_events = function(text) {
      var parser;
      parser = new Parser(new TestReceiver);
      parser.parse(text);
      return parser.receiver.output();
    };

    Playground.npmyamlmaster_json = function(text) {
      var data;
      data = npmYAML.parse(text);
      return JSON.stringify(data, null, 2);
    };

    Playground.npmyamlmaster_event = function(text) {
      var error, events, ref;
      ref = npmYAML.events(text), events = ref.events, error = ref.error;
      if (error != null) {
        throw error;
      }
      return events.join("\n");
    };

    Playground.npmyaml1_json = function(text) {
      var data;
      data = npmYAML1.parse(text);
      return JSON.stringify(data, null, 2);
    };

    Playground.npmyaml1_event = function(text) {
      var error, events, ref;
      ref = npmYAML1.events(text), events = ref.events, error = ref.error;
      if (error != null) {
        throw error;
      }
      return events.join("\n");
    };

    Playground.npmyaml2_json = function(text) {
      var data;
      data = npmYAML2.parse(text);
      return JSON.stringify(data, null, 2);
    };

    Playground.npmyaml2_event = function(text) {
      var error, events, ref;
      ref = npmYAML2.events(text), events = ref.events, error = ref.error;
      if (error != null) {
        throw error;
      }
      return events.join("\n");
    };

    Playground.npmjsyaml_json = function(text) {
      var data;
      data = npmJSYAML.load(text);
      return JSON.stringify(data, null, 2);
    };

    Playground.hs_refparser_yeast = function(text) {
      var value;
      value = this.localhost_server(text, 'cmd=hs-reference-yeast');
      if (_.isString(value) && value.match(/\ =REST\|/)) {
        throw value;
      } else {
        return value;
      }
    };

    Playground.yamlpp_events = function(text) {
      return this.sandbox_events(text, 'cmd=perl-pp-event');
    };

    Playground.npmyaml_events = function(text) {
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
      } catch (error1) {
        e = error1;
        throw 'Try: docker run --rm -d -p 31337:8000 yamlio/...';
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
      help = loc.replace(/(\/playground\/).*/, "$1#setting-up-a-local-sandbox");
      return {
        mark: "This pane requires a localhost sandbox server.\n\nRun:\n\n```\n$ docker run --rm -d -p " + port + ":" + port + " \\\n    yamlio/playground-sandbox:0.0.5 " + scheme + "\n```\n\n\non the same computer as your web browser.\n\nSee " + help + "  \nfor more instructions."
      };
    };

    return Playground;

  })();

}).call(this);
