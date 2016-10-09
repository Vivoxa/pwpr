# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@password = 'min700si'

    def random_string(length)
      (0...length).map { (65 + rand(26)).chr }.join
    end

    schemes = Scheme.create([{ name: 'dans pack scheme' }, { name: 'my pack scheme' }, { name: 'pack one' }, { name: 'Test scheme' }, { name: 'Synergy' }, { name: 'Packaging for you' }])
    roles = %w[scheme_owner scheme_full_access scheme_user_r scheme_owner scheme_full_access]
    company_roles = %w[company_owner company_full_access company_user_r company_user_rw company_owner company_full_access ]

    5.times do |index|
      user =SchemeOperator.create({ email: "#{roles[index]}_#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              scheme_ids: schemes[index].id})
      user.add_role roles[index]
    end

    3.times do |index|
      user = SchemeOperator.create({ email: "scheme_operator_owner#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              scheme_ids:[ schemes[index].id,schemes[ index + 1].id]})
      user.add_role :scheme_owner
    end

    5.times do |index|
      user =CompanyOperator.create({ email: "#{company_roles[index]}_#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              scheme_id: schemes[index].id})
      user.add_role company_roles[index]
    end

    3.times do |index|
      user = Admin.create({ email: "admin#{index}@pwpr.com",
                              password: @password })
      user.add_role :full_access
    end

