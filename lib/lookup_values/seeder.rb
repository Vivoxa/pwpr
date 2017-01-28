module LookupValues
  class Seeder
    def populate_lookup_tables
      lookup_tables = YAML.load_file(File.join(__dir__, './lookup_tables.yml'))

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

    private

    def get_columns(columns, lookup_tables, table_name)
      %w(column_1 column_2 column_3 column_4).each do |column_name|
        if lookup_tables[table_name][column_name]
          column = lookup_tables[table_name][column_name]
          columns << column
        end
      end
    end

    def get_values(columns, lookup_tables, table_name)
      value_count = lookup_tables[table_name]['column_1']['values'].size
      timestamp = Time.now.localtime.strftime '%Y-%m-%d %H:%M:%S'
      values = ''

      value_count.times do |index|
        values << '('
        columns.each do |column|
          case column['data_type']
            when 'integer'
              values << "#{column['values'][index]},"
            when 'string'
              values << "'#{column['values'][index]}',"
            when 'decimal'
              values << "#{column['values'][index]},"
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
  end
end
