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
      var data, e, resp;
      try {
        resp = $.ajax({
          type: 'POST',
          url: "http://0.0.0.0:5000/?" + args,
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
      return "This requires a localhost sandbox server.\nSimply run:\n\n$ docker run --rm \\\n    --network host \\\n    --publish 5000:5000 \\\n    yamlio/yaml-spec-playground-server:0.0.1\n\non the same computer as your web browser.";
    };

    return PlayGround;

  })();

}).call(this);
