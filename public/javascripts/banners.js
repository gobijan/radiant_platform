var BannerAd = new Class({
  initialize: function (element) {    
    this.background = element;
    this.foreground = element.getElement('img');
    this.background.addEvent('mouseenter', this.up.bindWithEvent(this));
    this.background.addEvent('mouseleave', this.down.bindWithEvent(this));
    this.down();
  },
  up: function() {    
    this.foreground.setStyle('opacity', 1);
  },
  down: function() {    
    this.foreground.fade(0.25);
  }
});






activations.push(function (scope) {
	scope.getElements('#banner').each(function (div) { new BannerAd(div); });
});
