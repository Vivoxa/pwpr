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

    schemes = Scheme.create([{ name: 'dans pack scheme' }, { name: 'mypack scheme' }, { name: 'pack one' }, { name: 'Test scheme' }, { name: 'Synergy' }, { name: 'Packaging for you' }])
    roles = %w[sc_director sc_super_user sc_user_r sc_user_rw sc_user_rwe sc_director sc_super_user]
    company_roles = %w[co_director co_contact co_user_r co_user_rw co_director co_contact ]
    names = ["Nigel","Dave","Lorand","Vicki","Andrew","Andi"]
    businesses = Business.create([{name: 'dans pack business', membership_id: 'mem-01'}, { name: 'my pack business', membership_id: 'mem-02' }, {name: 'pack one business', membership_id: 'mem-03' }, {name: 'test business', membership_id: 'mem-04' }, {name: 'synergy business', membership_id: 'mem-05' }, { name: 'pack for you business', membership_id: 'mem-06' }])
    schemes.each_with_index do |scheme, index|
      businesses[index].scheme = scheme
      businesses[index].save!
    end

                                 5.times do |index|
      user =SchemeOperator.create({ email: "#{roles[index]}_#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              name: names[index],
                              scheme_ids: schemes[index].id})
      user.add_role roles[index]
    end

    3.times do |index|
      user = SchemeOperator.create({ email: "scheme_operator_owner#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              name: names[index],
                              scheme_ids:[ schemes[index].id,schemes[ index + 1].id]})
      user.add_role :sc_director
    end

    5.times do |index|
      user =CompanyOperator.create({ email: "#{company_roles[index]}_#{index}@pwpr.com",
                              password: @password,
                              confirmation_token: random_string(20),
                              confirmation_sent_at: DateTime.now,
                              confirmed_at: DateTime.now,
                              name: names[index],
                              business_id: businesses[index].id})
      user.add_role company_roles[index]
    end

    3.times do |index|
      user = Admin.create({ email: "admin#{index}@pwpr.com",
                              name: names[index],
                              password: @password })
      user.add_role :full_access
    end
