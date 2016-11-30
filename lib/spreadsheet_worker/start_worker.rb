#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'worker'
require_relative 'connection_helper'
worker = SpreadsheetWorker::Worker.new
worker.start
