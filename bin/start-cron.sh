#!/bin/sh

bundle exec rails runner "WasteNotification.perform"
bundle exec rails runner "CleanUpService.perform"
bundle exec rails runner "CategoryService.update_all_defaults"
bundle exec rails runner "PushNotification.perform_schedule"
bundle exec rails runner "EventRecordService.update_sort_dates"
bundle exec rake doorkeeper:db:cleanup
