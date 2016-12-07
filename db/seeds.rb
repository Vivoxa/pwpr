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

sic = SicCode.create(code: 'SIC101', active: true, year_introduced: '2013')

schemes = Scheme.create([{name: 'dans pack scheme'},
                         {name: 'mypack scheme'},
                         {name: 'pack one'},
                         {name: 'Test scheme', active: true},
                         {name: 'Synergy'},
                         {name: 'Packaging for you', active: true}
                        ])

businesses = Business.create([{name: 'dans pack business', membership_id: 'mem-01', NPWD: 'NPWD-1', sic_code_id: sic.id},
                              {name: 'my pack business', membership_id: 'mem-02', NPWD: 'NPWD-1', sic_code_id: sic.id},
                              {name: 'pack one business', membership_id: 'mem-03', NPWD: 'NPWD-1', sic_code_id: sic.id},
                              {name: 'test business', membership_id: 'mem-04', NPWD: 'NPWD-1', sic_code_id: sic.id},
                              {name: 'synergy business', membership_id: 'mem-05', NPWD: 'NPWD-1', sic_code_id: sic.id},
                              {name: 'pack for you', membership_id: 'mem-06', NPWD: 'NPWD-1', sic_code_id: sic.id}])

agency_templates = AgencyTemplateUpload.create([{year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2001-03-30T04:05:06+07:00'),
                                                 uploaded_by_type: 'SchemeOperator',
                                                 uploaded_by_id: 1},
                                                {year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2015-11-23T04:05:06+07:00'),
                                                 uploaded_by_type: 'SchemeOperator',
                                                 uploaded_by_id: 1},
                                                {year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2002-06-22T04:05:06+07:00'),
                                                 uploaded_by_type: 'SchemeOperator',
                                                 uploaded_by_id: 1},
                                                {year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2004-04-14T04:05:06+07:00'),
                                                 uploaded_by_type: 'Admin',
                                                 uploaded_by_id: 1},
                                                {year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2010-02-11T04:05:06+07:00'),
                                                 uploaded_by_type: 'Admin',
                                                 uploaded_by_id: 1},
                                                {year: '2015',
                                                 filename: ActionDispatch::Http::UploadedFile.new(tempfile: 'public/favicon.ico', filename: 'favicon.ico'),
                                                 uploaded_at: DateTime.parse('2010-02-11T04:05:06+07:00'),
                                                 uploaded_by_type: 'Admin',
                                                 uploaded_by_id: 1}
                                               ])
schemes.each_with_index do |scheme, index|
  businesses[index].scheme = scheme
  businesses[index].save!
  agency_templates[index].scheme_id = scheme.id
  agency_templates[index].save!
end

#************************************************************************************
#                           Admins
#************************************************************************************
super_admin = Admin.create(email: 'super_admin@pwpr.com',
                           password: 'min700si',
                           name: 'Nigel')

super_admin.add_role :super_admin
super_admin.remove_role :restricted_admin

PermissionsForRole::AdminDefinitions.new.permissions_for_role(:super_admin).each do |permission, has|
  super_admin.add_role permission if has[:checked]
end

normal_admin = Admin.create({email: 'normal_admin@pwpr.com',
                             name: 'normal_admin',
                             password: @password})
normal_admin.normal_admin!
normal_admin.remove_role :restricted_admin

PermissionsForRole::AdminDefinitions.new.permissions_for_role(:normal_admin).each do |permission, has|
  normal_admin.add_role permission if has[:checked]
end

restricted_admin = Admin.create({email: 'restricted_admin@pwpr.com',
                                 name: 'restricted_admin',
                                 password: @password})

restricted_admin.restricted_admin!
PermissionsForRole::AdminDefinitions.new.permissions_for_role(:restricted_admin).each do |permission, has|
  restricted_admin.add_role permission if has[:checked]
end

2.times do |index|
#************************************************************************************
#                                 Scheme Operators
#************************************************************************************
  sc_director = SchemeOperator.create({email: "sc_director_#{index}@pwpr.com",
                                       password: @password,
                                       confirmation_token: random_string(20),
                                       invitation_sent_at: DateTime.now - 5.days,
                                       invitation_accepted_at: DateTime.now,
                                       confirmation_sent_at: DateTime.now - 5.days,
                                       confirmed_at: DateTime.now,
                                       first_name: "sc_director_#{index}",
                                       approved: true,
                                       scheme_ids: schemes[0].id})

  sc_director.sc_director!
  sc_director.remove_role :sc_user

  PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
    sc_director.add_role permission if has[:checked]
  end

  sc_super_user = SchemeOperator.create({email: "sc_super_user_#{index}@pwpr.com",
                                         password: @password,
                                         confirmation_token: random_string(20),
                                         invitation_sent_at: DateTime.now - 5.days,
                                         invitation_accepted_at: DateTime.now,
                                         confirmation_sent_at: DateTime.now - 5.days,
                                         confirmed_at: DateTime.now,
                                         first_name: "sc_super_user_#{index}",
                                         approved: true,
                                         scheme_ids: [schemes[1].id, schemes[2].id]})

  sc_super_user.sc_super_user!
  sc_super_user.remove_role :sc_user

  PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_super_user).each do |permission, has|
    sc_super_user.add_role permission if has[:checked]
  end

  sc_user = SchemeOperator.create({email: "sc_user_#{index}@pwpr.com",
                                   password: @password,
                                   confirmation_token: random_string(20),
                                   invitation_sent_at: DateTime.now - 5.days,
                                   invitation_accepted_at: DateTime.now,
                                   confirmation_sent_at: DateTime.now - 5.days,
                                   confirmed_at: DateTime.now,
                                   first_name: "sc_user_#{index}",
                                   approved: true,
                                   scheme_ids: [schemes[3].id, schemes[4].id]})

  PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_user).each do |permission, has|
    sc_user.add_role permission if has[:checked]
  end

#************************************************************************************
#                                 Company Operators
#************************************************************************************
  co_director = CompanyOperator.create({email: "co_director_#{index}@pwpr.com",
                                        password: @password,
                                        confirmation_token: random_string(20),
                                        invitation_sent_at: DateTime.now - 5.days,
                                        invitation_accepted_at: DateTime.now,
                                        confirmation_sent_at: DateTime.now - 5.days,
                                        confirmed_at: DateTime.now,
                                        first_name: "co_director_#{index}",
                                        approved: true,
                                        business_id: businesses[0].id})

  co_director.co_director!
  co_director.remove_role :co_user
  PermissionsForRole::CompanyOperatorDefinitions.new.permissions_for_role(:co_director).each do |permission, has|
    co_director.add_role permission if has[:checked]
  end

  co_super_user = CompanyOperator.create({email: "co_super_user_#{index}@pwpr.com",
                                          password: @password,
                                          confirmation_token: random_string(20),
                                          invitation_sent_at: DateTime.now - 5.days,
                                          invitation_accepted_at: DateTime.now,
                                          confirmation_sent_at: DateTime.now - 5.days,
                                          confirmed_at: DateTime.now,
                                          first_name: "co_super_user_#{index}",
                                          approved: true,
                                          business_id: businesses[1].id})

  co_super_user.co_super_user!
  co_super_user.remove_role :co_user

  PermissionsForRole::CompanyOperatorDefinitions.new.permissions_for_role(:co_super_user).each do |permission, has|
    co_super_user.add_role permission if has[:checked]
  end


  co_user = CompanyOperator.create({email: "co_user_#{index}@pwpr.com",
                                    password: @password,
                                    confirmation_token: random_string(20),
                                    invitation_sent_at: DateTime.now - 5.days,
                                    invitation_accepted_at: DateTime.now,
                                    confirmation_sent_at: DateTime.now - 5.days,
                                    confirmed_at: DateTime.now,
                                    first_name: "co_user_#{index}",
                                    approved: true,
                                    business_id: businesses[2].id})

  co_super_user.co_user!

  PermissionsForRole::CompanyOperatorDefinitions.new.permissions_for_role(:co_user).each do |permission, has|
    co_user.add_role permission if has[:checked]
  end
end
