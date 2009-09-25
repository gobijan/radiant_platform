# Fat Radiant

This is a standard installation of radiant, with all the extensions we normally use to support the kind of participative site we normally make. It might possibly be useful to other people so I've made it open, but it's not your standard radiant blog installation.

## Purpose

Most radiant sites are built in three layers. Mine are, anyway:

* Radiant and extensions
* site-specific static files: images, css, javascripts
* files delivered from the database (including images, css and javascripts)

The static site-specific layer is a fudgy mess, as a rule, and becomes a great nuisance when you run multi-sited. This Platform is an attempt to standardise our installations so that apart from radiant itself there is only platform code and database content. The platform is always generic and common to all our sites. The database is always site-specific.

This means working through the admin interface more than one might want, but it becomes obvious after a while: your stylesheets are pages delivered with an empty layout and the content type text/css. When you want to use a background image in a stylesheet, upload it as an asset and put something like this in the css rule:

	background-image: url(<r:assets:url id="99" />);
	
The rest is normal.

## Installation

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

## Importing an existing site

Much the same as the installation described above except for two slightly awkward steps: migrating the extensions and moving content into the database.

### Extension Migrations

The dependencies here mean that you can't just run db:migrate:extensions. This sequence seems to work:

	rake radiant:extensions:made_easy:migrate
	rake radiant:extensions:reader:migrate
	rake radiant:extensions:forum:migrate
	rake radiant:extensions:taggable:migrate
	rake radiant:extensions:paperclipped:migrate
	rake db:migrate:extensions

but it will depend where you're coming from.

### Moving content into the database

No rocket science here: you need to take any site-specific images, stylesheets and javascripts and recreate them in the database. This will involve empty layouts for scripts and styles, with the right content-types, probably some uploading of the images you use for page furniture and then the dull but easy replacement of any image references in your stylesheets.



Any questions, contact Will on will at spanner dot org.