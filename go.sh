#!/bin/sh
export USE_SIM_LAUNCHER_SERVER=YES
bundle install --deployment
bundle exec rake ci
