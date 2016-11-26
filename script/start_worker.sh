#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../lib/spreadsheet_worker/worker'
require_relative '../lib/spreadsheet_worker/connection_helper'
SpreadsheetWorker::Worker.new.start