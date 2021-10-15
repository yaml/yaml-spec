(function() {
  var run;

  window.say = console.log;

  window.mmap = {};

  window.nmap = {};

  window.omap = {};

  window.goto = function(e) {
    return e.scrollIntoView();
  };

  run = function() {
    var $m, $n, $o, IO, height, io, m, n, o, ref;
    ref = $('iframe'), m = ref[0], n = ref[1], o = ref[2];
    $m = $(m.contentDocument);
    $n = $(n.contentDocument);
    $o = $(o.contentDocument);
    $n.find('h1,h2,h3,h4').each(function() {
      var tag, text;
      tag = this.tagName;
      text = $(this).text().replace(/^Chapter\s+(\d+\.)+\s+.*/, 'Chapter $1').replace(/^(\d+\.)+\s+/, '');
      return nmap[tag + " " + text] = this;
    });
    $n.find('p').each(function() {
      var children, text;
      children = this.childNodes;
      if (children.length === 1 && children[0].tagName === 'STRONG') {
        text = $(children[0]).text().replace(/\s+/g, ' ').replace(/\s$/, '').replace(/^Example\s+\d+\.\d+\s+/, 'Example ').replace(/^Figure\s+\d+\.\d+\.\s+/, 'Figure ');
        return nmap["HB " + text] = this;
      }
    });
    $o.find('h1,h2,h3,h4').each(function() {
      var tag, text;
      tag = this.tagName;
      text = $(this).text();
      if (text.match(/^\s*Chapter\s+\d+\.\s+/)) {
        tag = 'H1';
      }
      text = text.replace(/\s+/g, ' ').replace(/^\s/, '').replace(/\s$/, '').replace(/^Chapter\s+(\d+\.)+\s+.*/, 'Chapter $1').replace(/^(\d+\.)+\s+/, '');
      return omap[tag + " " + text] = this;
    });
    $o.find('B').each(function() {
      var text;
      text = $(this).text().replace(/^\s+/, '');
      if (!text.match(/^(Figure|Example|Status|Abstract|Table)/)) {
        return;
      }
      text = text.replace(/\s+/g, ' ').replace(/\s$/, '').replace(/^Example\s+\d+\.\d+\.\s+/, 'Example ').replace(/^Figure\s+\d+\.\d+\.\s+/, 'Figure ');
      return omap["HB " + text] = this;
    });
    IO = $('iframe')[0].contentWindow.IntersectionObserver;
    height = 200 - document.documentElement.scrollHeight;
    mmap['# Chapter #. Introduction to YAML'] = 'H1 Chapter 1.';
    mmap['# Chapter #. Language Overview'] = 'H1 Chapter 2.';
    mmap['# Chapter #. Processes and Models'] = 'H1 Chapter 3.';
    mmap['# Chapter #. Syntax Conventions'] = 'H1 Chapter 4.';
    mmap['# Chapter #. Character Productions'] = 'H1 Chapter 5.';
    mmap['# Chapter #. Structural Productions'] = 'H1 Chapter 6.';
    mmap['# Chapter #. Flow Style Productions'] = 'H1 Chapter 7.';
    mmap['# Chapter #. Block Style Productions'] = 'H1 Chapter 8.';
    mmap['# Chapter #. Document Stream Productions'] = 'H1 Chapter 9.';
    mmap['# Chapter #. Recommended Schemas'] = 'H1 Chapter 10.';
    io = new IO(function(e) {
      var h, l, t;
      if (!e[0].isIntersecting) {
        return;
      }
      h = $(e[0].target).text();
      if (mmap[h] != null) {
        t = mmap[h];
      } else if (h.match(/^(#{1,4})\s/)) {
        l = RegExp.$1;
        l = l.length;
        h = h.replace(/^#+\s+/, '');
        h = h.replace(/^\#\.\s+/, '');
        t = "H" + l + " " + h;
      } else if (h.match(/^\*\*/)) {
        h = h.replace(/^\*\*/, '').replace(/\*\*$/, '').replace(/\s+/g, ' ').replace(/Example\s+\#\.\s+/, 'Example ').replace(/Figure\s+\#\.\s+/, 'Figure ');
        t = "HB " + h;
      }
      try {
        goto(nmap[t]);
      } catch (error) {}
      try {
        return goto(omap[t]);
      } catch (error) {}
    }, {
      rootMargin: "0px 0px " + height + "px 0px",
      threshold: [1]
    });
    return $m.find('code').each(function() {
      return io.observe(this);
    });
  };

  $(document).ready(function() {
    var m, n, o, wait;
    m = $('iframe')[0].contentDocument;
    n = $('iframe')[1].contentDocument;
    o = $('iframe')[2].contentDocument;
    wait = function() {
      say('wait');
      if (m.readyState === 'complete' && n.readyState === 'complete' && o.readyState === 'complete') {
        return setTimeout(function() {
          return run();
        }, 500);
      } else {
        return setTimeout(wait, 500);
      }
    };
    return wait();
  });

}).call(this);
