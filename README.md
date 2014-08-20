# Overview

Glow is a tool that generates [Sparkle-compatible](/andymatuschak/Sparkle) Appcast 
update feeds and html release notes for your Mac projects. It's _not_ a full blown, 
database driven, multiple project supporting, update releasing laser canon. Rather 
it's a clean, easy to use script that will automate 90% of releasing updates to your
users.

The templates are text transformed by [Jekyll](http://jekyllrb.com/).

# Features

* Automatically fetches file size, version number, build number and signature
from new releases.
* Supports regular as well as beta builds by looking at the version number.
* Supports Markdown for writing release notes.
* Automatically updates the index page after each new update.
* Automatically generates a new page for each update.
* Supports .zip and .dmg releases.
* Clean and simple theme included.
* Easily add your own theme by changing templates and css.

# Prerequisites

* A basic understanding of how Sparkle works.
* An app with updates to deploy.
* A server to host your updates.

# How Glow Works

* Glow looks for an `.app` file.
* Glow parses the `Info.plist` of your app bundle for its version number, build
number and creation date.
* Glow checks if a compressed update file exists.
* Glow optionally generates a Sparkle signature using your private key.
* Glow checks the compressed update's file size.
* Glow generates a new Jekyll-compatible file with the information above.
* Glow creates (or updates) a symbolic link called `YourApp-latest.zip/dmg`
that points to the latest update. If the latest addition isn't a beta release.
* Jekyll generates html release notes and Appcast feeds for regular and beta
releases.

# Status

Glow powers release notes and automatic updates for all [Danger Cove](http://www.dangercove.com) apps.

# Setup

## Directory Structure

Create a new folder and lay it out like this:

    .
    |- dsa_priv.pem (optional)
    |- sign_update.rb (optional)
    |- YourApp.app

`sign_update.rb` is included with Sparkle and `dsa_priv.pem` is generated using
`generate_keys.rb`, also included with Sparkle. Signatures are optional but
recommended, especially for unsigned apps. For signed apps, Sparkle will check
if the identity of the update matches the original's.

Enter your newly created folder and clone glow.

    $ git clone git@github.com:DangerCove/glow.git glow

Go into `glow` and type `rake setup`. This will install (a) gem(s) and create
 (a) folder(s). (This sentence is super future proof.)

The final directory structure looks like this.

    .
    |- dsa_priv.pem
    |- sign_update.rb
    |- glow/
    |  |- _config-sample.yml (rename to _config.yml and edit)
    |  |- _drafts/
    |  |- _includes/ (html header and footer)
    |  |- _layouts/ (page and update html layout)
    |  |- _posts/ (will contain update release notes)
    |  |- _site/ (things you will deploy, created after first run)
    |     |- download/ (actual update binaries)
    |     |- update/ (generated update pages)
    |        |- appcast-beta.rss (regular + beta updates)
    |        |- appcast.rss (regular updates)
    |        |- .. generated html files
    |  |- appcast-beta.rss (beta rss template)
    |  |- appcast.rss (regular rss template)
    |  |- css/ (style sheets)
    |  |- glow.rb (script that does all the work)
    |  |- .. project files 
    |- YourApp.app

## Customize

Rename `_config-sample.yml` to `_config.yml` and open it in your favorite
editor.

Change the following lines. The rest is optional.

    url: http://update.project.com
    file_host: http://download.project.com
    title: Your Project for Mac Updates
    description: This feed contains application updates.
    google_analytics: UA-12345678-90

Change your `index.html` page title in `index.md`.

# Adding Updates

## Regular Update

* Replace `YourApp.app` with the latest version.
* Note the version number of `YourApp.app`. `0.3` for instance.
* Compress `YourApp.app` and rename the zip (or dmg) to `YourApp-v[version number].zip`.
`YourApp-v0.3.zip` for instance.
* Copy it to `glow/_site/download`.
* Run `rake add`.

This will create a new post in `glow/_posts/`. Open that in your editor as
well. It should look something like this.

    ---
    layout: update
    title: 
    time: 2013-10-22 11:03:58 +0200
    version: 0.3
    bundle: 1
    signature: [random bunch of characters]
    file_size: 3810620
    file: YourApp-v0.3b.zip
    ---

    * Bugfixes

Enter your release notes where it says `* Bugfixes` and add a title if you
want.

## Beta Update

Follow the steps above, only make sure your version number ends with `b` (customizable
in `_config.yml`). For instance: `0.3b`.

You'll notice after generating a post, it will have an extra property: `beta: true`.

## Previewing the Updates

Run `rake preview` and open `http://localhost:4000/`.

## Deploying

Working on this. I'm rsyncing the contents of `_site` to my server. Would love
to be able to have different deploy options.

For now, running `rake deploy` will execute a script called `deploy.sh` inside the `_site` folder.
  
# Known Issues

* The directory structure is rather strict.
* App names need to be equal to compressed file names. Could cause trouble for
app names with spaces.
* (Currently) no support for more advanced Sparkle settings, like
minimumSystemVersion. Shouldn't be too hard to add though.

# Contributions and Things to add

Keep in mind that Glow is meant to be simple and easy to customize. Feel free to 
restructure code. It's currently very, ehm, procedural.

Things I'd like to add:

* Deployment options.
* Automatic zipping or dmg-creating (using [Dropdmg](http://c-command.com/dropdmg/) for instance).
* Add the build number after the beta indicator to allow for multiple beta builds 
for one version number, e.g. Tapetrap-v0.3b10.zip and Tapetrap-v0.3b11.zip.

# License

New BSD License, see `LICENSE` for details.
