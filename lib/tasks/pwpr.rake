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
end