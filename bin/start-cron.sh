#!/bin/sh

bundle exec rails runner "WasteNotification.new.send_notifications"
bundle exec rails runner "CleanUpService.perform"
bundle exec rails runner "CategoryService.update_all_defaults"
bundle exec rails runner "PushNotification.new.schedule_notifications"
