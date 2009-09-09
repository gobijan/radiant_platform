var posts = [];

window.addEvent('domready', function(){
  getNavBar();
  activate(document);
});

activate = function(container) {
  getPosts(container);
  getRemoteContent(container);
  flashErrors(container);
  fadeNotices();
}

var block = function (e) {
  if (e) {
    if (e.target) e.target.blur();
    e = new Event(e);
    e.preventDefault();
    e.stop;
    return e;
  }
};

// get rid of radiant notifications (after a pause)

fadeNotices = function () {
  reallyFadeNotices.delay(2000);
}

reallyFadeNotices = function () {
  $$('div#notice').fade('out');
  $$('div#error').fade('out');
}

// flash validation errors

flashErrors = function (container) {
  container.getElements('p.with_errors').each(function (element) { element.highlight(); });
}

// ajax shortcutting: brings forms into the page in a degradable way

getRemoteContent = function (container) {
  container.getElements('a.remote_content').each(function (a) { replaceWithDestination(a); });
};

replaceWithDestination = function (a) {
  var destination = a.get('href');
  var holder = new Element('div', {'class' : 'remote_content'});
  var waiter = new Element('p', {'class' : 'waiting'}).set('text', a.get('text'));
  waiter.inject(holder);
  holder.replaces(a);
  holder.set('load', {onComplete: function () { activate(holder); }});
  holder.load(destination);
}

// initialize the post machinery: editable, deletable and (soon) flaggable in place

getPosts = function (container) {
  if (!container) container = document;
  container.getElements('div.post').each(function (div) { posts.push(new Post(div)); });
};

var Post = new Class({
  initialize: function (div) {
    this.container = div;
    this.header = div.getElement('div.post_header');
    this.wrapper = div.getElement('div.post_wrapper');
    this.body_holder = div.getElement('div.post_body');
    this.h = this.body_holder.getHeight();
    this.editor = div.getElement('a.edit_post');
    if (this.editor) {
      this.editor.addEvent('click', this.edit.bindWithEvent(this));
    }
    this.showing = false;
    this.form_holder = null;
    this.form = null;
  },
  
  edit: function(e){
    block(e);
    this.editor.addClass('waiting');
    if (this.showing) this.cancel();
    else if (this.form_holder) this.prepForm();
    else this.getForm(this.editor.get('href'));
  },
  
  getForm: function (url) {
    if (url) this.formHolder().load(url);
  },
  
  formHolder: function () {
    if (this.form_holder) return this.form_holder;
    this.form_holder = new Element('div', {'class': 'post_form'});
    this.form_holder.set('load', {onComplete: this.prepForm.bind(this)});
    return this.form_holder;
  },
  
  prepForm: function () {
    this.form_holder.inject(this.wrapper, 'top');
    this.body_holder.hide();
    this.editor.removeClass('waiting');
    this.form = this.form_holder.getElement('form');
    this.input = this.form.getElement('textarea');
    this.input.setStyle('height', this.h);
    this.form_holder.getElement('a.cancel').addEvent('click', this.cancel.bindWithEvent(this));
    this.uploader = new UploadHandler(this.form_holder.getElement('div.upload_handler'));
    this.stumbit = this.form_holder.getElement('div.buttons');
    this.form.onsubmit = this.sendForm.bind(this);
    // new Fx.Morph(this.input, {duration: 'short'}).start({'height' : 240, opacity : 1});
    this.form_holder.show();
    this.showing = true;
  },
  
  sendForm: function (e) {
    var waiter = new Element('p', {'class' : 'waiting'}).set('text', 'please wait');
    waiter.replaces(this.stumbit);

    if (this.uploader && this.uploader.hasUploads()) {
      // can't send uploads over xmlhttp so we allow the form to submit
      // the update-post action will redirect to a hashed url that should return us to the right post
    } else {
      block(e);
      new Request.HTML({
        url: this.form.get('action'),
        update: this.container,
        onComplete: this.finishEdit.bind(this)
      }).post(this.form);
    }
    
  },
  cancel: function (e) {
    block(e);
    this.finishCancel();
    // new Fx.Morph(this.input, {duration: 'short', onComplete : this.finishCancel.bind(this)}).start({'height' : this.h, opacity : 0});
  },
  finishCancel: function () {
    this.form_holder.hide();
    this.body_holder.show();
    this.editor.removeClass('waiting');
    this.showing = false;
  },
  finishEdit: function () {
    this.container.highlight();
    new Post(this.container);
  }
});

var UploadHandler = new Class({
  initialize: function (div) {
    this.container = div;
    this.shower = div.getElement('a');
    this.list = div.getElement('ul.attachments');
    this.pender = div.getElement('div.uploads');
    this.selector = div.getElement('div.selector');

    this.file_field_template = this.selector.getElement('input').clone();
    this.file_pending_template = new Element('li');

    this.attachments = [];
    this.list.getElements('li.attachment').each(function (li) {
      this.attachments.push( new Attachment(li));
    }, this);

    this.uploads = [];
    this.uploader = this.selector.getElement('input');
    this.uploader.addEvent('change', this.addUpload.bindWithEvent(this));

    this.reveal = new Fx.Slide(div.getElement('div.hidden_attachments'));
    this.shower.addEvent('click', this.toggle.bindWithEvent(this));

    if (!this.hasAttachments()) this.reveal.hide();
  },
  toggle: function (e) {
    block(e);
    this.reveal.toggle();
  },
  addUpload: function (e) {
    block(e);
    this.uploads.push(new Upload(this));
    this.resize();
  },
  pendUpload: function (argument) {
    var ul = this.uploader.clone().inject(this.pender);
    this.uploader.set('value', null);
    return ul;
  },
  hasAttachments: function () {
    return this.attachments.length > 0;
  },
  hasUploads: function () {
    return this.uploads.length > 0;
  },
  resize: function () {
    this.reveal.slideIn();
  }
});

var Upload = new Class({
  initialize: function (handler) {
    this.handler = handler;
    this.uploader = this.handler.pendUpload();
    this.container = new Element('li', {'class': 'attachment'}).set('text', ' ' + this.uploader.value + ' ');
    this.icon = new Element('img').set('src', this.icon_for(this.uploader.value)).inject(this.container, 'top');
    this.remover = new Element('a', {'class': 'remove', 'href': '#'}).set('text', 'remove').inject(this.container, 'bottom');
    this.remover.addEvent('click', this.remove.bindWithEvent(this));
    this.container.inject(this.handler.list, 'bottom');
  },
  icon_for: function (filename) {
    return '/images/forum/icons/attachment_new.png';
  },
  remove: function (e) {
    block(e);
    this.uploader.destroy();
    this.container.nix();
    this.handler.resize();
  }
});

var Attachment = new Class({
  initialize: function (li) {
    this.container = li;
    this.checkbox = li.getElement('input.choose_attachment');
    this.remover = li.getElement('a.remove');
    this.remover.addEvent('click', this.remove.bindWithEvent(this));
  },
  remove: function (e) {
    block(e);
    if (this.checkbox) this.checkbox.set('checked', false);
    this.container.nix();
  },
  hide: function () {
    this.container.hide();
  }
});


// KTP navigation: very simple dropdown linklist

getNavBar = function () {
  var div = $('navigation');
  if (div) new NavBar(div);
}

var NavBar = new Class({
  initialize: function (div) {
    this.div = div;
    this.timer = null;
    this.opento = this.div.getHeight();
    this.closeto = 0;
    var nb = this;
    this.openFX = new Fx.Tween(this.div, {
      'property': 'height',
      'duration': 'normal', 
      'transition': 'bounce:out', 
      'onStart': function () { nb.div.addClass('open'); nb.state = 'opening';}, 
      'onComplete': function () { nb.state = 'open';}
    });
    this.closeFX = new Fx.Tween(this.div, {
      'property': 'height',
      'duration': 'long', 
      'transition': 'cubic:out', 
      'onStart': function () { nb.state = 'closing'; }, 
      'onComplete': function () { nb.div.removeClass('open'); nb.state = 'closed';}
    });
    this.closeFX.set(this.closeto);
    this.state = 'closed';
    this.div.setStyle('visibility', 'visible');
    
    var openbar = this.open.bindWithEvent(this);
    var closebar = this.close.bindWithEvent(this);
    var closebarsoon = this.closeSoon.bindWithEvent(this);
    var cancelclose = this.cancelClose.bindWithEvent(this);
    
    this.div.addEvent('mouseenter', openbar);
    this.div.addEvent('mouseleave', closebarsoon);
    $$('.hidenav').each(function (a) { 
      a.onclick = closebar;
    });
    $$('.shownav').each(function (a) { 
      a.onmouseover = openbar;
      a.onmouseout = closebarsoon;
    });
  },
  open: function (e) {
    block(e);
    this.cancelClose();
    if (this.state.contains('clos')) {
      if (this.state == 'closing') this.closeFX.cancel();
      this.openFX.start(this.opento);
    }
  },
  close: function (e) {
    block(e);
    if (this.state.contains('open')) {
      if (this.state == 'opening') this.openFX.cancel();
      this.closeFX.start(this.closeto);
    }
  },
  closeSoon: function (e) {
    block(e);
    var nb = this;
    this.timer = (function () { nb.close(); }).delay(500);
  },
  cancelClose: function (e) {
    block(e);
    $clear(this.timer);
  }
});
