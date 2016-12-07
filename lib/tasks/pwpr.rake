def get_columns(columns, lookup_tables, table_name)
  column_1 = lookup_tables[table_name]['column_1']
  columns << column_1

  if lookup_tables[table_name]['column_2']
    column_2 = lookup_tables[table_name]['column_2']
    columns << column_2
  end

  if lookup_tables[table_name]['column_3']
    column_3 = lookup_tables[table_name]['column_3']
    columns << column_3
  end

  if lookup_tables[table_name]['column_4']
    column_4 = lookup_tables[table_name]['column_4']
    columns << column_4
  end
end

def get_values(columns, lookup_tables, table_name)
  value_count = lookup_tables[table_name]['column_1']['values'].size
  timestamp = Time.now.localtime.strftime '%Y-%m-%d %H:%M:%S'
  values = ''

  value_count.times do |index|
    values << "("
    columns.each do |column|
      if column['data_type'] == 'integer'
        values << "#{column['values'][index]},"
      else
        values << "'#{column['values'][index]}',"
      end
    end
    values << "'#{timestamp}','#{timestamp}')"
    values << ',' unless index == (value_count - 1)
  end
  values
end

def truncate_table(table_name)
  delete_query = "DELETE FROM  #{table_name} "
  ActiveRecord::Base.connection.execute(delete_query)
  puts 'Records deleted.........'
end

def populate_table(columns, table_name, values)
  column_names = columns.each.map { |x| x['title'] }.join(',')
  insert_lookups_query = "INSERT INTO #{table_name} (#{column_names}, created_at, updated_at) VALUES #{values};"

  ActiveRecord::Base.connection.execute(insert_lookups_query)
end

namespace :pwpr do

  desc 'Populate lookup tables'
  task :populate_lookup_tables, [:env] => :environment do |t, args|
    if args[:env].nil?
      p 'Rails environment required'
      next
    end

    p 'STARTED - populating lookup tables'

    lookup_tables = YAML.load_file(File.join(__dir__, '../lookup_values/lookup_tables.yml'))

    lookup_tables.keys.each do |table_name|

      columns = []

      get_columns(columns, lookup_tables, table_name)
      values = get_values(columns, lookup_tables, table_name)

      puts

      puts 'Removing existing records from ' + table_name
      truncate_table(table_name)

      puts 'Inserting new records into ' + table_name

      populate_table(columns, table_name, values)

      puts table_name + '............DONE'
      puts
    end
  end
end