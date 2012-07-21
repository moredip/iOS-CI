#!/bin/sh
bundle install --deployment

rm -rf ci_artifacts
bundle exec rake ci
