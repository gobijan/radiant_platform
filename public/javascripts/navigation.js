var NavBar = new Class({
  initialize: function (element) {    
    this.div = element;
    this.opento = this.div.getHeight();
    this.closeto = 23;
    this.timer = null;
    var nb = this;
    this.openFX = new Fx.Tween(this.div, {
      'property': 'height',
      'duration': 'normal',
      'transition': 'bounce:out',
      'onStart': function () {        
        nb.div.addClass('open');
        nb.state = 'opening';
      },
      'onComplete': function () {        
        nb.state = 'open';
      }
    });
    this.closeFX = new Fx.Tween(this.div, {
      'property': 'height',
      'duration': 'long',
      'transition': 'cubic:out',
      'onStart': function () {        
        nb.state = 'closing';
      },
      'onComplete': function () {        
        nb.div.removeClass('open');
        nb.state = 'closed';
      }
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
    $$('a.hidenav').each(function (a) {      
      a.onclick = closebar;
    });
    $$('a.shownav').each(function (a) {      
      a.onmouseover = openbar;
      a.onmouseout = closebarsoon;
    });
  },
  open: function (e) {    
    this.cancelClose(e);
    if (this.state.contains('clos')) {      
      if (this.state == 'closing') this.closeFX.cancel();
      this.openFX.start(this.opento);
    }
  },
  close: function (e) {    
    if (this.state.contains('open')) {      
      if (this.state == 'opening') this.openFX.cancel();
      this.closeFX.start(this.closeto);
    }
  },
  closeSoon: function (e) {    
    var nb = this;
    this.timer = (function () { nb.close(e); }).delay(1500);
  },
  cancelClose: function (e) {      
    if (e) e.block();
    $clear(this.timer);
  }
});






activations.push(function (scope) {
	scope.getElements('#navigation').each(function (div) { new NavBar(div); });
});
