## Fat Radiant

This is a standard installation of radiant, with all the extensions we normally use to support the kind of participative site we normally make. It might possibly be useful to other people so I've made it open, but it's not your standard radiant blog installation.

### Purpose

Most radiant sites are built in three layers. Mine are, anyway:

* Radiant and extensions
* site-specific static files: images, css, javascripts
* files delivered from the database (including images, css and javascripts)

The static site-specific layer is a fudgy mess, as a rule, and becomes a great nuisance when you run multi-sited. This Platform is an attempt to standardise our installations so that apart from radiant itself there is only platform code and database content. The platform is always generic and common to all our sites. The database is always site-specific.

This means working through the admin interface more than one might want, but it becomes obvious after a while: your stylesheets are pages delivered with an empty layout and the content type text/css. When you want to use a background image in a stylesheet, upload it as an asset and put something like this in the css rule:

	background-image: url(<r:assets:url id="99" />);
	
The rest is normal.

### Installation

1. Check this out:

	git clone git://github.com/spanner/radiant_platform.git your_site_name

2. Get the submodules

	git submodule init
	git submodule update
	
3. Add a few site-specific files. There are (or will be soon) anonymised templates for each of these included in the distribution:

* config/database.yml
* config/deploy.rb
* config/nginx.conf (or whatever you prefer)
* public/robots.txt
* public/favicon.ico

4. Bootstrap the database

	rake db:bootstrap
	
5. Migrate the extensions

	rake db:migrate:extensions

6. Update all the extensions. At the moment you have to do this by hand because I haven't finished the combined update task. Or indeed started it.

Any questions, contact Will on will at spanner dot org.