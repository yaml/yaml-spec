(function() {
  var $,
    slice = [].slice;

  if (window.jQuery != null) {
    $ = jQuery;
  } else {
    throw "EatMe requires is jQuery to be loaded first.";
  }

  window.qqq = function(a) {
    window.q = a;
    return a;
  };

  window.say = function() {
    var a, i, len, o;
    a = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    for (i = 0, len = a.length; i < len; i++) {
      o = a[i];
      console.dir(o, {
        depth: 10
      });
    }
    return a[0];
  };

  window.EatMe = (function() {
    EatMe.configs = {};

    EatMe.objects = [];

    EatMe.conf = function(conf) {
      var slug;
      conf = new EatMe.Config(conf);
      slug = conf.slug;
      if (this.configs[slug] != null) {
        throw "Eatme conf '" + slug + "' already exists";
      }
      this.configs[slug] = conf;
      return slug;
    };

    EatMe.init = function(arg) {
      var $elem, code, conf, config, elem;
      elem = arg.elem, conf = arg.conf, code = arg.code;
      if (elem instanceof jQuery) {
        $elem = elem;
      } else if (_.isString(elem) || elem instanceof Element) {
        $elem = $(elem);
      } else {
        throw "Bad 'elem' argument for EatMe.init";
      }
      if (!(config = this.configs[conf])) {
        throw "No EatMe.Config named '" + conf + "' found";
      }
      return $elem.each(function() {
        var eatme;
        eatme = new EatMe(this, config, code);
        return EatMe.objects.push(eatme);
      });
    };

    function EatMe(from1, conf1, code1) {
      this.from = from1;
      this.conf = conf1;
      this.code = code1;
      if ((this.code != null) && (this.code.init != null)) {
        this.code.init(this);
      }
      this.make_root();
      this.make_cols();
      this.start();
    }

    EatMe.prototype.make_root = function() {
      var $from;
      $from = $(this.from);
      if ($from[0].tagName !== 'PRE') {
        throw "Can only make EatMe from '<pre>'";
      }
      return this.root = $(this.conf.html).addClass('eatme-container');
    };

    EatMe.prototype.make_cols = function() {
      var $col, $pane, col, cols, column, i, j, len, pane, ref, ref1, self, size;
      this.panes = $('<div hidden>').appendTo(this.root);
      cols = this.conf.cols;
      size = 12 / cols;
      for (col = i = 1, ref = cols; 1 <= ref ? i <= ref : i >= ref; col = 1 <= ref ? ++i : --i) {
        $col = this.make_col(size);
        this.root.append($col);
      }
      ref1 = this.conf.pane;
      for (j = 0, len = ref1.length; j < len; j++) {
        pane = ref1[j];
        if ((column = pane.colx) != null) {
          $col = $(this.root.find(".eatme-col")[column - 1]);
          $pane = this.make_pane(pane.slug).appendTo($col);
          this.setup_pane($pane);
        }
      }
      self = this;
      return this.root.find('.eatme-col').each(function() {
        $col = $(this);
        if ($col.find('.eatme-pane').length === 0) {
          return self.make_empty_pane().appendTo($col);
        }
      });
    };

    EatMe.prototype.start = function() {
      return $(this.from).replaceWith(this.root);
    };

    EatMe.prototype.make_resizable = function() {
      return this.root.splitobj = Split(this.root.find('.col').toArray(), {
        elementStyle: function(dimension, size, gutterSize) {
          return {
            'flex-basis': "calc(" + size + "% - " + gutterSize + "px)"
          };
        },
        gutterStyle: function(dimension, gutterSize) {
          return {
            'flex-basis': gutterSize + "px"
          };
        },
        sizes: [20, 60, 20],
        minSize: 150,
        gutterSize: 6,
        cursor: 'col-resize'
      });
    };

    EatMe.prototype.make_col = function(size) {
      return $("<div class=\"eatme-col col col-lg-" + size + "\">");
    };

    EatMe.prototype.switch_pane = function($old, $new) {
      var self;
      self = this;
      this.root.find('.eatme-col .eatme-pane').each(function() {
        var $pane, $replaced;
        $pane = $(this);
        if ($pane.attr('id') === $new.attr('id')) {
          $replaced = $pane.replaceWith(self.make_empty_pane());
          if (!$replaced.attr('id').match(/^empty-/)) {
            return self.panes.append($replaced);
          }
        }
      });
      this.panes.append($old.replaceWith($new).appendTo(this.panes));
      return this.setup_pane($new);
    };

    EatMe.prototype.setup_pane = function($pane) {
      var $textarea, base, call, calls, conf, copy_button, from, func, pane, pane_id, self, text;
      self = this;
      pane_id = $pane.attr('id');
      if (pane_id.match(/^empty-/)) {
        pane_id = 'empty';
      }
      $pane.find('select').val(pane_id).attr('pane', pane_id);
      copy_button = $pane.find('.eatme-btn-copy-text')[0];
      $pane.clipboard = new ClipboardJS(copy_button, {
        target: function(btn) {
          return self.copy_text($(btn));
        }
      });
      conf = this.conf.panes[pane_id];
      if ((call = conf.call) != null) {
        func = call[0], from = call[1];
        calls = (base = this.root.find(".eatme-pane-" + from)[0]).calls || (base.calls = []);
        calls.push([func, $pane]);
      }
      pane = $pane[0];
      conf = pane.eatme;
      if (conf.type === 'input' && (pane.cm == null)) {
        $textarea = $pane.find('textarea');
        text = this.input != null ? this.input : $(this.from).text();
        if (text) {
          $textarea.text(text);
        } else {
          $textarea.text("\n");
        }
        return setTimeout(function() {
          var cm, do_calls;
          pane.cm = cm = CodeMirror.fromTextArea($textarea[0], {
            lineNumbers: true
          });
          do_calls = function() {
            var $to, i, len, ref, results;
            text = cm.getValue();
            if ((self.code != null) && (self.code.change != null)) {
              self.code.change(text, pane);
            }
            results = [];
            ref = pane.calls;
            for (i = 0, len = ref.length; i < len; i++) {
              call = ref[i];
              func = call[0], $to = call[1];
              results.push(self.call(func, text, $to));
            }
            return results;
          };
          cm.on('change', $.debounce(400, do_calls));
          return setTimeout(function() {
            do_calls();
            cm.focus();
            return cm.setCursor({
              line: 0,
              ch: 0
            });
          }, 200);
        }, 100);
      }
    };

    EatMe.prototype.call = function(func, text, $to) {
      var e, error, show;
      func = func.replace(/-/g, '_');
      try {
        show = this.code[func](text);
        if (_.isString(show)) {
          show = {
            output: show
          };
        }
      } catch (error1) {
        e = error1;
        error = (e.stack || e.msg || e).toString();
        show = {
          error: error
        };
      }
      return this.show($to, show);
    };

    EatMe.prototype.show = function($pane, show) {
      var $box, $show, error, html, markdown, output, pane;
      pane = $pane[0];
      if ((html = show.html) != null) {
        $box = pane.$html.html(html);
      } else if ((markdown = show.mark) != null) {
        $box = pane.$html.html(marked(markdown));
      } else if ((error = show.error) != null) {
        $box = pane.$error.text(error);
      } else if ((output = show.output) != null) {
        $box = pane.$output.text(output);
      } else {
        throw "Invalid show value: '" + show + "'";
      }
      $show = $pane.children().last();
      if ($show[0] !== $box[0]) {
        return $show.replaceWith($box);
      }
    };

    EatMe.empty = 1;

    EatMe.prototype.make_empty_pane = function() {
      var num, pane, slug;
      num = EatMe.empty++;
      slug = "empty-" + num;
      pane = {
        name: 'Empty',
        slug: slug,
        type: 'text'
      };
      return this.make_pane(pane);
    };

    EatMe.prototype.make_pane = function(pane) {
      var $box, $pane;
      if (_.isString(pane)) {
        pane = this.conf.panes[pane] || (function() {
          throw "Unknown pane id '" + pane + "'";
        })();
      }
      $pane = $("<div\n  id=\"" + pane.slug + "\"\n  class=\"eatme-pane eatme-pane-" + pane.slug + "\"\n>").append(this.make_nav());
      $pane[0].eatme = pane;
      $pane[0].$output = $('<pre class="eatme-box">');
      $pane[0].$error = $('<pre class="eatme-box eatme-error">');
      $pane[0].$html = $('<div class="eatme-box">');
      if (pane.type === 'input') {
        $box = $('<textarea class="eatme-box">');
      } else if (pane.type === 'error') {
        $box = $('<pre class="eatme-box eatme-errors">');
      } else {
        $box = $('<pre class="eatme-box">');
      }
      if (pane.load != null) {
        $box.load(pane.load);
      } else {
        $box.html(pane.text || '');
      }
      $pane.append($box);
      return $pane;
    };

    EatMe.prototype.make_nav = function() {
      return $('<div class="eatme-nav">').append(this.make_toolbar()).append(this.make_pane_select());
    };

    EatMe.prototype.make_pane_select = function() {
      var $select, i, len, pane, ref, self;
      self = this;
      $select = $("<select class=\"eatme-select form-select form-select-lg\">\n  <option value=\"empty\">Choose a Pane</option>\n</select>");
      $select.on('change', function() {
        return self.select_changer(this.value, $select);
      });
      ref = this.conf.pane;
      for (i = 0, len = ref.length; i < len; i++) {
        pane = ref[i];
        $("<option value=\"" + pane.slug + "\">" + pane.name + "</option>").appendTo($select);
      }
      return $select;
    };

    EatMe.prototype.select_changer = function(id, $select) {
      var $new, $old;
      $old = $select.closest('div.eatme-pane');
      $new = $("#" + id);
      if ($new.length !== 1) {
        if (id === 'empty') {
          $new = this.make_empty_pane();
        } else {
          $new = this.make_pane(id);
        }
      }
      return this.switch_pane($old, $new);
    };

    EatMe.prototype.add_pane = function($button, e) {
      var $col, $pane, panes;
      $col = $button.closest('.eatme-col');
      panes = $col.find('div.eatme-pane').length;
      if (panes < 4) {
        e.stopPropagation();
        $pane = this.make_empty_pane();
        return $col.append($pane);
      }
    };

    EatMe.prototype.close_pane = function($button) {
      var $col, $pane;
      $pane = $button.closest('.eatme-pane');
      $col = $pane.closest('.eatme-col');
      if ($col.find('.eatme-pane').length > 1) {
        return $pane.appendTo(this.panes);
      }
    };

    EatMe.prototype.move_pane = function($button) {
      var $pane;
      $pane = $button.closest('.eatme-pane');
      return $pane.next().after($pane);
    };

    EatMe.prototype.add_col = function($button) {
      var $col, $cols, cols, size_new, size_old;
      $col = $button.closest('.eatme-col');
      $cols = $col.parent().find('.eatme-col');
      cols = $cols.length;
      if (!(cols < 4)) {
        return;
      }
      size_old = 12 / cols++;
      size_new = 12 / cols;
      $cols.toggleClass("col-lg-" + size_old + " col-lg-" + size_new);
      return this.make_col(size_new).insertAfter($col);
    };

    EatMe.prototype.close_col = function($button) {
      var $col, $cols, cols, size_new, size_old;
      $col = $button.closest('.eatme-col');
      $cols = $col.parent().find('.eatme-col');
      cols = $cols.length;
      if (!(cols > 1)) {
        return;
      }
      size_old = 12 / cols--;
      size_new = 12 / cols;
      $col.find('.eatme-pane').appendTo(this.panes);
      $col.remove();
      return $cols.toggleClass("col-lg-" + size_old + " col-lg-" + size_new);
    };

    EatMe.prototype.move_col = function($button) {
      var $col;
      $col = $button.closest('.eatme-col');
      return $col.next().after($col);
    };

    EatMe.prototype.copy_text = function($button) {
      var $textarea;
      $textarea = $button.closest('.eatme-pane').find('textarea');
      if ($textarea.length > 0) {
        return $textarea[0];
      }
    };

    EatMe.prototype.clear_text = function($button) {
      return $button.closest('.eatme-pane').find('textarea').val('').focus();
    };

    EatMe.prototype.zoom_in = function($button, e) {
      var $pane, size;
      e.stopPropagation();
      $pane = $button.closest('.eatme-pane');
      size = $pane.css('font-size').replace(/px$/, '');
      if (!(size < 25)) {
        return;
      }
      size++;
      return $pane.css('font-size', size + "px");
    };

    EatMe.prototype.zoom_out = function($button, e) {
      var $pane, size;
      e.stopPropagation();
      $pane = $button.closest('.eatme-pane');
      size = $pane.css('font-size').replace(/px$/, '');
      if (!(size > 7)) {
        return;
      }
      size--;
      return $pane.css('font-size', size + "px");
    };

    EatMe.prototype.toggle_error = function($button) {
      var $error, $pane, error;
      $pane = $button.closest('.eatme-pane');
      if (($error = $pane.find('.eatme-box-error')).length === 0) {
        $error = $('<pre class="eatme-box-error" style="display:none">').appendTo($pane);
        if ((error = $pane[0].error) != null) {
          $error.text(error);
        }
      }
      return $pane.find('.eatme-box, .eatme-box-error').toggle();
    };

    EatMe.prototype.make_toolbar = function() {
      var $li, $toolbar, $ul, btn, i, j, len, len1, line, ref, self;
      self = this;
      $toolbar = $(EatMe.toolbar_div);
      $ul = $toolbar.find('ul');
      ref = EatMe.toolbar;
      for (i = 0, len = ref.length; i < len; i++) {
        line = ref[i];
        $li = $('<li>').appendTo($ul);
        for (j = 0, len1 = line.length; j < len1; j++) {
          btn = line[j];
          this.make_button(btn, $toolbar).appendTo($li);
        }
      }
      return $toolbar;
    };

    EatMe.prototype.make_button = function(id, $tools) {
      var $btn, btn, func, self;
      btn = EatMe.buttons[id];
      $btn = $("<a\n  class=\"eatme-btn-" + id + "\"\n  title=\"" + btn.name + "\">\n  <i class=\"bi-" + btn.icon + "\" />\n</a>");
      if (btn.dead == null) {
        self = this;
        func = btn.func || id.replace(/-/g, '_');
        $btn.attr({
          'href': '#'
        });
        $tools.on('click', ".eatme-btn-" + id, function(e) {
          return self[func]($(this), e);
        });
      }
      return $btn;
    };

    EatMe.toolbar_div = "<div class=\"eatme-btns dropdown\">\n  <button\n    class=\"btn btn-default dropdown-toggle eatme-toolbar-btn\"\n    type=\"button\"\n    data-toggle=\"dropdown\"\n    title=\"Pane toolbar\"\n  ></button>\n\n  <ul class=\"dropdown-menu\">\n  </ul>\n</div>";

    EatMe.toolbar = [['toggle-error', 'edit-pane', 'copy-text', 'clear-text', 'zoom-in', 'zoom-out'], ['pause-auto', 'start-auto', 'permalink', 'settings'], ['add-pane', 'close-pane', 'move-pane'], ['add-col', 'close-col', 'move-col']];

    EatMe.buttons = {
      'toggle-error': {
        name: 'Toggle Error Display',
        icon: 'exclamation-square'
      },
      'edit-pane': {
        name: 'Edit this pane',
        icon: 'pencil-square',
        dead: true
      },
      'copy-text': {
        name: 'Copy pane text',
        icon: 'files'
      },
      'clear-text': {
        name: 'Clear pane text',
        icon: 'x-square'
      },
      'zoom-in': {
        name: 'Increase font size',
        icon: 'zoom-in'
      },
      'zoom-out': {
        name: 'Decrease font size',
        icon: 'zoom-out'
      },
      'pause-auto': {
        name: 'Pause auto run',
        icon: 'pause-circle',
        dead: true
      },
      'start-auto': {
        name: 'Start auto run',
        icon: 'play-circle',
        dead: true
      },
      'permalink': {
        name: 'Get permalink',
        icon: 'link',
        dead: true
      },
      'settings': {
        name: 'Pane settings',
        icon: 'gear',
        dead: true
      },
      'add-pane': {
        name: 'Add new pane to column',
        icon: 'plus-square'
      },
      'close-pane': {
        name: 'Close this pane',
        icon: 'dash-square'
      },
      'move-pane': {
        name: 'Move this pane down one',
        icon: 'arrow-down-square'
      },
      'add-col': {
        name: 'Add new column to right',
        icon: 'plus-square-fill'
      },
      'close-col': {
        name: 'Close this column',
        icon: 'dash-square-fill'
      },
      'move-col': {
        name: 'Move this column right',
        icon: 'arrow-right-square-fill'
      }
    };

    return EatMe;

  })();

  EatMe.Config = (function() {
    function Config(conf) {
      var ref;
      ref = [conf, this, 'top level'], this.src = ref[0], this.trg = ref[1], this.lvl = ref[2];
      this.required_slug('slug');
      this.optional_num('cols', 1, 4);
      this.required_str('html');
      this.pane = [];
      this.panes = {};
      this.set_panes();
      delete this.src;
      delete this.trg;
      delete this.lvl;
    }

    Config.prototype.set_panes = function() {
      var i, len, obj, objs, pane, ref, results1;
      if (((objs = this.src.pane) == null) || !_.isArray(objs)) {
        throw "EatMe.Config requires 'pane' array";
      }
      results1 = [];
      for (i = 0, len = objs.length; i < len; i++) {
        obj = objs[i];
        if (!_.isPlainObject(obj)) {
          throw "Each element of 'pane' array must be an object";
        }
        pane = {};
        ref = [obj, pane, 'pane object'], this.src = ref[0], this.trg = ref[1], this.lvl = ref[2];
        this.required_str('name');
        this.required_slug('slug');
        pane.type = null;
        this.set_call();
        this.optional_str('mark');
        this.optional_str('html');
        this.optional_num('colx', 1, 4);
        this.set_type();
        this.pane.push(pane);
        results1.push(this.panes[this.trg.slug] = pane);
      }
      return results1;
    };

    Config.prototype.set_type = function() {
      var type;
      type = this.src.type;
      if (type == null) {
        if (this.trg.call != null) {
          type = 'text';
        } else if ((this.trg.mark != null) || this.trg.html) {
          type = 'html';
        } else {
          say(this.src);
          throw "No 'type' value set";
        }
      }
      return this.trg.type = type;
    };

    Config.prototype.set_call = function() {
      var call;
      if ((call = this.src.call) == null) {
        return;
      }
      if ((!_.isArray(call)) || !(_.isString(call[0]) && _.isString(call[1]))) {
        throw "EatMe.Config 'call' value must be array of strings";
      }
      return this.trg.call = call;
    };

    Config.prototype.required = function(name) {
      var value;
      if ((value = this.src[name]) == null) {
        throw "Config value '" + name + "' required for " + this.lvl;
      }
      return value;
    };

    Config.prototype.required_str = function(name) {
      var value;
      value = this.required(name);
      this.validate_str(value, name);
      return this.trg[name] = value;
    };

    Config.prototype.required_slug = function(name) {
      var value;
      value = this.required(name);
      this.validate_slug(value, name);
      return this.trg[name] = value;
    };

    Config.prototype.optional_str = function(name) {
      var value;
      if ((value = this.src[name]) == null) {
        return;
      }
      this.validate_str(value, name);
      return this.trg[name] = value;
    };

    Config.prototype.optional_num = function(name, min, max) {
      var value;
      if ((value = this.src[name]) == null) {
        return;
      }
      if ((!_.isNumber(value)) || value < min || value > max) {
        throw "Invalid value '" + value + "' for '" + name + "', must be a number from " + min + " to " + max;
      }
      return this.trg[name] = value;
    };

    Config.prototype.validate_str = function(value, name) {
      if (!_.isString(value)) {
        throw "Invalid value '" + value + "' for '" + name + "' in '" + this.lvl + "', must be a string";
      }
    };

    Config.prototype.validate_slug = function(value, name) {
      if (!value.match(/^[-a-z0-9]+$/)) {
        throw "Invalid slug value '" + value + "'";
      }
    };

    return Config;

  })();

}).call(this);
