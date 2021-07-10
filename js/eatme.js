(function() {
  var die, qqq, say,
    slice = [].slice;

  qqq = function(a) {
    window.q = a;
    return a;
  };

  say = function() {
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

  die = function(msg) {
    if (msg == null) {
      msg = 'Died';
    }
    throw msg.toString();
  };

  window.EatMe = (function() {
    EatMe.conf = {
      cols: 2
    };

    EatMe.init = function(root, conf, func) {
      var $root, eatme;
      EatMe.set = [];
      if (root instanceof jQuery) {
        $root = root;
      } else if (_.isString(root)) {
        $root = $(root);
      } else {
        die("Bad 'root' argument for EatMe.init");
      }
      this.normalize(conf);
      eatme = new EatMe($root, conf, func);
      EatMe.set.push(eatme);
      return eatme;
    };

    function EatMe(root1, conf1, func1) {
      var $first, text;
      this.root = root1;
      this.conf = conf1;
      this.func = func1;
      this.panes = $('<div hidden>').appendTo(this.root);
      this.make_cols();
      $first = $(this.root).find('.eatme-pane:has(textarea)').first();
      if ($first.length === 1) {
        text = $first.find('.eatme-box').focus().text();
        this.call(text, $first);
      }
    }

    EatMe.normalize = function(conf) {
      var i, len, pane, ref, results;
      this.pane_map = {};
      ref = conf.pane;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        pane = ref[i];
        if (pane.slug == null) {
          pane.slug = pane.name.toLowerCase().replace(/\ /g, '-');
        }
        if (pane.type == null) {
          if ((pane.load != null) && pane.load.match(/\.html$/)) {
            pane.type = 'html';
          } else {
            pane.type = 'edit';
          }
        }
        results.push(this.pane_map[pane.slug] = pane);
      }
      return results;
    };

    EatMe.prototype.make_cols = function() {
      var $col, $pane, col, cols, i, idx, j, len, pane, ref, ref1, ref2, size;
      cols = this.conf.conf.cols;
      if ((ref = cols.toString()) !== '2' && ref !== '3' && ref !== '4') {
        die("'cols' must be 2, 3 or 4");
      }
      size = 12 / cols;
      for (col = i = 1, ref1 = cols; 1 <= ref1 ? i <= ref1 : i >= ref1; col = 1 <= ref1 ? ++i : --i) {
        $col = this.make_col(size);
        this.root.append($col);
      }
      ref2 = this.conf.pane;
      for (j = 0, len = ref2.length; j < len; j++) {
        pane = ref2[j];
        if (pane.init != null) {
          idx = Number(pane.init.replace(/^col-/, '')) - 1;
          $col = $(this.root.find(".eatme-col")[idx]);
          $pane = this.make_pane(pane.slug).appendTo($col);
          this.setup_pane($pane);
        }
      }
      return this.root.find('.eatme-col').each(function() {
        $col = $(this);
        if ($col.find('.eatme-pane').length === 0) {
          return this.make_empty_pane().appendTo($col);
        }
      });
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
      var copy_button, pane_id, self;
      self = this;
      pane_id = $pane.attr('id');
      if (pane_id.match(/^empty-/)) {
        pane_id = 'empty';
      }
      $pane.find('select').val(pane_id).attr('pane', pane_id);
      $pane.find('textarea').bind('change keyup', $.debounce(400, function() {
        return self.call($(this).val(), $pane);
      }));
      copy_button = $pane.find('.eatme-btn-copy-text')[0];
      return $pane.clipboard = new ClipboardJS(copy_button, {
        target: function(btn) {
          return self.copy_text($(btn));
        }
      });
    };

    EatMe.prototype.call = function(text, $from) {
      var $to, all_errors, dest, e, error, from, func, i, len, ref, ref1, show, to;
      from = EatMe.pane_map[$from.attr('id')];
      all_errors = '';
      ref = from.call;
      for (i = 0, len = ref.length; i < len; i++) {
        ref1 = ref[i], func = ref1[0], dest = ref1[1];
        func = func.replace(/-/g, '_');
        to = EatMe.pane_map[dest];
        $to = $(".eatme-pane-" + dest);
        try {
          show = this.func[func](text);
          if (_.isString(show)) {
            say(typeof show);
            show = {
              output: show
            };
          }
        } catch (error1) {
          e = error1;
          error = (e.stack || e.msg || e).toString();
          all_errors += ("*** Errors in '" + to.name + "' ***\n" + error) + "\n\n";
          show = {
            error: error
          };
        }
        this.show($to, show);
      }
      return $('.eatme-errors').text(all_errors);
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
        die("Invalid show value: '" + show + "'");
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
        pane = EatMe.pane_map[pane] || die("Unknown pane id '" + pane + "'");
      }
      $pane = $("<div\n  id=\"" + pane.slug + "\"\n  class=\"eatme-pane eatme-pane-" + pane.slug + "\"\n>").append(this.make_nav());
      $pane[0].$output = $('<pre class="eatme-box">');
      $pane[0].$error = $('<pre class="eatme-box eatme-error">');
      $pane[0].$html = $('<div class="eatme-box">');
      if (pane.type === 'edit') {
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

}).call(this);
