#!/bin/sh

bundle exec rails runner "WasteNotification.new.send_notifications"
