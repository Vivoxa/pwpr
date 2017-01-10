namespace :pwpr do

  # bundle exec rake pwpr:populate_lookup_tables[development]
  desc 'Populate lookup tables'
  task :populate_lookup_tables, [:env] => :environment do |_t, args|
    if args[:env].nil?
      p 'Rails environment required'
      next
    end

    p 'STARTED - populating lookup tables'

    seeder = LookupValues::Seeder.new
    seeder.populate_lookup_tables
  end

  desc 'start the rabbitmq spreadsheet worker'
  task :start_spreadsheet_queue_worker, [:env] => :environment do |_t, _args|
    spreadsheet_worker = SpreadsheetWorker::Worker.new(ENV['SPREADSHEET_QUEUE_NAME'],
                                                       ENV['SPREADSHEET_QUEUE_HOST'],
                                                       ENV['SPREADSHEET_WORKER_LOG_PATH'])
    spreadsheet_worker.start
  end

  desc 'start the rabbitmq reporting worker'
  task :start_reporting_queue_worker, [:env] => :environment do |_t, _args|
    reporting_worker = Reporting::Worker.new(ENV['REPORTS_QUEUE_NAME'],
                                             ENV['REPORTS_QUEUE_HOST'],
                                             ENV['REPORTS_WORKER_LOG_PATH'])
    reporting_worker.start
  end

  desc 'create the super admin user'
  task :create_super_admin, [:env] => :environment do |_t, _args|
    begin
      p 'Creating admin user'
      super_admin = Admin.create!(email: 'super_admin@pwpr.com',
                                  password: 'MyS3cur3Phr@s3',
                                  name: 'Super Admin')

      p "Created Admin with id: #{super_admin.id}"

      p 'Adding Super Admin role'
      super_admin.add_role :super_admin

      p 'Removing restricted admin role assigned by default'
      super_admin.remove_role :restricted_admin

      p 'Assigning permissions for super admin'
      PermissionsForRole::AdminDefinitions.new.permissions_for_role(:super_admin).each do |permission, has|
        super_admin.add_role permission if has[:checked]
      end
    rescue => e
      p "Error: #{e.message}"
    end
  end
end
