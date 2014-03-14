#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Contributors'
SITENAME = 'Python Club'
SITESUBTITLE = 'at Queen Mary'
SITEURL = ''

TIMEZONE = 'Europe/London'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

THEME = 'themes/pelicanium'

# Menu
DISPLAY_CATEGORIES_ON_MENU = False
MENUITEMS = (
    ('Archive', 'archives.html'),
    ('Tags', 'tags.html'),
    ('Authors', 'authors.html'),
)

# Blogroll
LINKS = (
    ('Pelican', 'http://getpelican.com/'),
    ('Python.org', 'http://python.org/'),
    ('Jinja2', 'http://jinja.pocoo.org/'),
)

# Social widget
SOCIAL = (
    ('Facebook', 'https://www.facebook.com/groups/723364331026623/'),
    ('Twitter', 'https://twitter.com/pyclub_qm'),
)

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

DISQUS_SITENAME = 'pyclub'
GITHUB_URL = 'https://github.com/pyclub/pyclub.github.io'
GOOGLE_ANALYTICS = 'UA-47565959-1'
TWITTER_USERNAME = 'pyclub_qm'

STATIC_PATHS = (
    'static',
)
