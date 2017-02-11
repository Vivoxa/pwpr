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

seeder = LookupValues::DbLookupTables::Seeder.new
seeder.populate_lookup_tables

sic = SicCode.first

schemes = Scheme.create([{name: 'dans pack scheme', active: true, scheme_country_code_id: 1},
                         {name: 'mypack scheme', active: true, scheme_country_code_id: 1},
                         {name: 'pack one', active: true, scheme_country_code_id: 1},
                         {name: 'Test scheme', active: true, scheme_country_code_id: 1},
                         {name: 'Synergy', scheme_country_code_id: 1},
                         {name: 'Packaging for you', active: true, scheme_country_code_id: 1}
                        ])

businesses = Business.create([{name: 'dans pack business',
                               NPWD: 'NPWD-1',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               business_type_id: 1,
                               registration_status_code_id: 1},
                              {name: 'my pack business',
                               NPWD: 'NPWD-2',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               registration_status_code_id: 1},
                              {name: 'pack one business',
                               NPWD: 'NPWD-3',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               registration_status_code_id: 1},
                              {name: 'test business',
                               NPWD: 'NPWD-4',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               registration_status_code_id: 1},
                              {name: 'synergy business',
                               NPWD: 'NPWD-5',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               registration_status_code_id: 1},
                              {name: 'pack for you',
                               NPWD: 'NPWD-6',
                               sic_code_id: sic.id,
                               scheme_ref: '123',
                               company_number: '123456789',
                               country_of_business_registration_id: 1,
                               year_first_reg: '2007',
                               scheme_status_code_id: 1,
                               registration_status_code_id: 1}])

schemes.each_with_index do |scheme, index|
  businesses[index].scheme = scheme
  businesses[index].save!
end

registration_address = Address.new(address_type_id: 2,
                                   address_line_1: '108 houghton road',
                                   address_line_2: 'Hetton le hole',
                                   address_line_3: '',
                                   address_line_4: '',
                                   town: 'Houghton le spring',
                                   site_country: 'UK',
                                   telephone: '0191 5178644',
                                   fax: '0191 5174533',
                                   post_code: 'DH5 9PL',
                                   email: 'registration@hotmail.co.uk')

correspondence_address = Address.new(address_type_id: 4,
                                     address_line_1: '108 houghton road',
                                     address_line_2: 'Hetton le hole',
                                     address_line_3: '',
                                     address_line_4: '',
                                     town: 'Houghton le spring',
                                     site_country: 'UK',
                                     telephone: '0191 5178644',
                                     fax: '0191 5174533',
                                     post_code: 'DH5 9PL',
                                     email: 'correspondence@hotmail.co.uk')

audit_address = Address.new(address_type_id: 3,
                            address_line_1: '108 houghton road',
                            address_line_2: 'Hetton le hole',
                            address_line_3: '',
                            address_line_4: '',
                            town: 'Houghton le spring',
                            site_country: 'UK',
                            telephone: '0191 5178644',
                            fax: '0191 5174533',
                            post_code: 'DH5 9PL',
                            email: 'audit@hotmail.co.uk')

correspondence_contact = Contact.create(title: 'Mr',
                                        address_type_id: 4,
                                        first_name: 'Doc',
                                        last_name: 'Brown',
                                        email: 'nigelsurtees@hotmail.co.uk',
                                        telephone_1: '0191 6749933')

audit_contact = Contact.create(title: 'Mr',
                               address_type_id: 3,
                               first_name: 'Doc',
                               last_name: 'Brown',
                               email: 'nigelsurtees@hotmail1.co.uk',
                               telephone_1: '0191 6749933')

registered_contact = Contact.create(title: 'Mr',
                                    address_type_id: 2,
                                    first_name: 'Doc',
                                    last_name: 'Brown',
                                    email: 'nigelsurtees@hotmail1.co.uk',
                                    telephone_1: '0191 6749933')

business = businesses.first
business.contacts << correspondence_contact
business.contacts << audit_contact
business.contacts << registered_contact

business.addresses << registration_address
business.addresses << correspondence_address
business.addresses << audit_address

registration_address.save!
registration_address.contacts << correspondence_contact
registration_address.contacts << audit_contact
registration_address.contacts << registered_contact

#************************************************************************************
#                           Admins
#************************************************************************************
super_admin = Admin.create(email: 'super_admin@pwpr.com',
                           password: @password,
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
                                       last_name: 'surtees',
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
                                         last_name: 'surtees',
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
                                   last_name: 'surtees',
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
                                        last_name: 'surtees',
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
                                          last_name: 'surtees',
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
                                    last_name: 'surtees',
                                    password: @password,
                                    confirmation_token: random_string(20),
                                    invitation_sent_at: DateTime.now - 5.days,
                                    invitation_accepted_at: DateTime.now,
                                    confirmation_sent_at: DateTime.now - 5.days,
                                    confirmed_at: DateTime.now,
                                    first_name: "co_user_#{index}",
                                    approved: true,
                                    business_id: businesses[2].id})

  co_user.co_user!

  PermissionsForRole::CompanyOperatorDefinitions.new.permissions_for_role(:co_user).each do |permission, has|
    co_user.add_role permission if has[:checked]
  end

  co_user = CompanyOperator.create({email: "co_user_#{index+1}@pwpr.com",
                                    last_name: 'surtees',
                                    password: @password,
                                    confirmation_token: random_string(20),
                                    invitation_sent_at: DateTime.now - 5.days,
                                    invitation_accepted_at: DateTime.now,
                                    confirmation_sent_at: DateTime.now - 5.days,
                                    confirmed_at: DateTime.now,
                                    first_name: "co_user_#{index}",
                                    approved: false,
                                    business_id: businesses[2].id})

  co_user.co_user!

  PermissionsForRole::CompanyOperatorDefinitions.new.permissions_for_role(:co_user).each do |permission, has|
    co_user.add_role permission if has[:checked]
  end
end

  email_content = EmailContent.new
  email_content.email_content_type_id = EmailContentType.id_from_setting('default')
  email_content.email_name_id = EmailName.id_from_setting('registration_email')
  email_content.intro = 'Dear <first_name>'
  email_content.title = 'Registration form <year>'
  email_content.body = "The attached Registration Details Form includes the information that we currently hold for your company.\r\n\r\n We will use this information to register you with the Environment Agency.\r\n\r\nCould you please check these details carefully, amend where necessary and return a signed copy of this form to <scheme_name> by 28th February <year>. Please return a signed copy, even if there are no changes.\r\n\r\nWe are introducing this additional check to help maintain the accuracy of the data held by <scheme_name> and further ensure the compliance of our members. Any subsequent changes to company details, which come to light during the course of the year, could result in Environment Agency resubmission charges."
  email_content.address = "The Mill House\r\nMarket Place\r\nHoughton le Spring\r\nTyne and Wear\r\nDH5 8AH\r\n\r\nTel: 0191 512 6677\nCo Reg No: 04835772"
  email_content.footer = 'Please contact The Scheme at thescheme@app-pwpr.com'
  email_content.save!

