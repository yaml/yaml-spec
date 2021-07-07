(function() {
  window.PlayGround = (function() {
    function PlayGround() {}

    PlayGround.parse = function(text) {
      var parser;
      parser = new Parser(new TestReceiver);
      parser.parse(text);
      return parser.receiver.output();
    };

    PlayGround.eload = function(text) {
      return EYAML.parse(text);
    };

    return PlayGround;

  })();

}).call(this);
