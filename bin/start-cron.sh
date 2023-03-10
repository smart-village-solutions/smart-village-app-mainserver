#!/bin/sh

bundle exec rails runner "WasteNotification.new.send_notifications"
bundle exec rails runner "CleanUpService.new.perform"
bundle exec rails runner "CategoryService.new.update_all_defaults"
bundle exec rails runner "PushNotification.new.schedule_notifications"
bundle exec rake doorkeeper:db:cleanup
