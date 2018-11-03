#!/bin/sh

#
# Add to Startup Application Preferences:
# gnome-terminal --profile=dev -e /home/vidplayer/workspace/liveset/script/vidplayer/launch.sh
#

cd workspace/liveset
git checkout wl-demo-chromebox
bundle install --path vendor/bundle || true
bundle || true
bundle exec script/vidplayer/listen
