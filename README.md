## Platform

This is a standard installation of radiant, with all the extensions we normally use to support the kind of participative site we normally make. It might possibly be useful to other people so I've made it open, but it's not your standard radiant blog installation.

The idea is that the platform should be completely generic, but sufficient that you can make a completely different site by working only within the database.

All you need to do is add a few site-specific files:

* config/database.yml
* config/deploy.rb
* config/nginx.conf (or whatever you prefer)

There are (or will be soon) anonymised templates for each of these included in the distribution.

Run `rake db:bootstrap` and you're ready to go. If you want to keep the installation clean, all of your site-specific javascript and css has to be served by radiant.

Any questions, contact Will on will at spanner dot org.