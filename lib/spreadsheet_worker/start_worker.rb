#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'worker'
require_relative 'helper'
SpreadsheetWorker::Worker.start
