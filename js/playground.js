(function() {
  window.PlayGround = (function() {
    function PlayGround() {}

    PlayGround.parse = function(text) {
      return text.toUpperCase();
    };

    PlayGround.eload = function(text) {
      return EYAML.parse(text);
    };

    return PlayGround;

  })();

}).call(this);
