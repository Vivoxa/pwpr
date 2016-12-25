namespace :pwpr do

  # bundle exec rake pwpr:populate_lookup_tables[development]
  desc 'Populate lookup tables'
  task :populate_lookup_tables, [:env] => :environment do |t, args|
    if args[:env].nil?
      p 'Rails environment required'
      next
    end

    p 'STARTED - populating lookup tables'

    seeder = LookupValues::Seeder.new
    seeder.populate_lookup_tables
  end

  desc 'start the rabbitmq spreadsheet worker'
  task :start_spreadsheet_queue_worker, [:env] => :environment do |t, args|
    spreadsheet_worker = SpreadsheetWorker::Worker.new(ENV['SPREADSHEET_QUEUE_NAME'],
                                                       ENV['SPREADSHEET_QUEUE_HOST'],
                                                       ENV['SPREADSHEET_WORKER_LOG_PATH'])
    spreadsheet_worker.start
  end

  desc 'start the rabbitmq reporting worker'
  task :start_reporting_queue_worker, [:env] => :environment do |t, args|
    reporting_worker = Reporting::Worker.new(ENV['REPORTS_QUEUE_NAME'],
                                             ENV['REPORTS_QUEUE_HOST'],
                                             ENV['REPORTS_WORKER_LOG_PATH'])
    reporting_worker.start
  end
end
