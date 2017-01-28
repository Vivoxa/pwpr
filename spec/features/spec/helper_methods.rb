def sign_in(user_type, email, password)
  case user_type
    when 'Admin'
      visit '/admins/sign_in'
    when 'SchemeOperator'
      sign_in_btn_id = 'sc_login'
    when 'CompanyOperator'
      sign_in_btn_id = 'co_login'
  end

  if sign_in_btn_id
    visit '/'
    find_by_id('sign_in_out').click
    find_by_id(sign_in_btn_id).click
  end

  wait_for_page_load(:link_or_button, 'Log in')

  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_on 'Log in' # this be an Ajax button -- requires Selenium
end

def wait_for_page_load(name, text)
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop do
      case name
        when Symbol
          break if page.has_selector?(name, text)
        when String
          break if page.has_selector?(name, text: text)
      end

      page.evaluate_script("window.location.reload()")

    end
  end
end

def super_admin_definitions
  {
      admins_r: {checked: true, locked: true},
      admins_w: {checked: true, locked: true},
      admins_e: {checked: true, locked: true},
      admins_d: {checked: true, locked: true},

      schemes_r: {checked: true, locked: true},
      schemes_w: {checked: true, locked: true},
      schemes_e: {checked: true, locked: true},
      schemes_d: {checked: true, locked: true},

      sc_users_r: {checked: true, locked: true},
      sc_users_w: {checked: true, locked: true},
      sc_users_e: {checked: true, locked: true},
      sc_users_d: {checked: true, locked: true},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: true, locked: true},
      co_users_e: {checked: true, locked: true},
      co_users_d: {checked: true, locked: true},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: true, locked: true},
      businesses_w: {checked: true, locked: true},
      businesses_d: {checked: true, locked: true},
      uploads_r: {checked: true, locked: true},
      uploads_w: {checked: true, locked: true}
  }
end

def normal_admin_definitions
  {
      schemes_r: {checked: true, locked: true},
      schemes_w: {checked: false, locked: false},
      schemes_e: {checked: true, locked: true},
      schemes_d: {checked: false, locked: false},

      sc_users_r: {checked: true, locked: true},
      sc_users_w: {checked: true, locked: true},
      sc_users_e: {checked: true, locked: true},
      sc_users_d: {checked: false, locked: false},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: true, locked: true},
      co_users_e: {checked: true, locked: true},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: true, locked: true},
      businesses_w: {checked: true, locked: true},
      businesses_d: {checked: false, locked: false},
      uploads_r: {checked: true, locked: true},
      uploads_w: {checked: false, locked: false}
  }
end

def restricted_admin_definitions
  {
      schemes_r: {checked: true, locked: true},
      schemes_w: {checked: false, locked: true},
      schemes_e: {checked: false, locked: false},
      schemes_d: {checked: false, locked: true},

      sc_users_r: {checked: true, locked: true},
      sc_users_w: {checked: false, locked: false},
      sc_users_e: {checked: false, locked: false},
      sc_users_d: {checked: false, locked: true},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: false, locked: false},
      co_users_e: {checked: false, locked: false},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: false, locked: false},
      businesses_w: {checked: false, locked: true},
      businesses_d: {checked: false, locked: true},
      uploads_r: {checked: false, locked: false},
      uploads_w: {checked: false, locked: true}
  }
end

def co_director_definitions
  {
      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: true, locked: true},
      co_users_e: {checked: true, locked: true},
      co_users_d: {checked: true, locked: true},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: true, locked: true}
  }
end

def co_super_user_definitions
  {
      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: true, locked: true},
      co_users_e: {checked: true, locked: true},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: false, locked: false},
      businesses_e: {checked: false, locked: false}
  }
end

def co_user_definitions
  {
      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: false, locked: false},
      co_users_e: {checked: false, locked: false},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: false, locked: false},
      businesses_e: {checked: false, locked: true}
  }
end

def sc_director_definitions
  {
      schemes_r: {checked: true, locked: true},
      schemes_w: {checked: true, locked: true},
      schemes_e: {checked: true, locked: true},
      schemes_d: {checked: true, locked: true},

      sc_users_r: {checked: true, locked: true},
      sc_users_w: {checked: true, locked: true},
      sc_users_e: {checked: true, locked: true},
      sc_users_d: {checked: true, locked: true},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: true, locked: true},
      co_users_e: {checked: true, locked: true},
      co_users_d: {checked: true, locked: true},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: true, locked: true},
      businesses_w: {checked: true, locked: true},
      businesses_d: {checked: true, locked: true},
      uploads_r: {checked: true, locked: true},
      uploads_w: {checked: true, locked: true}
  }
end

def sc_super_user_definitions
  {
      schemes_r: {checked: true, locked: true},
      schemes_w: {checked: false, locked: false},
      schemes_e: {checked: true, locked: true},
      schemes_d: {checked: false, locked: false},

      sc_users_r: {checked: true, locked: true},
      sc_users_w: {checked: true, locked: true},
      sc_users_e: {checked: true, locked: true},
      sc_users_d: {checked: false, locked: false},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: false, locked: false},
      co_users_e: {checked: false, locked: false},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: true, locked: true},
      businesses_w: {checked: true, locked: true},
      businesses_d: {checked: false, locked: false},
      uploads_r: {checked: true, locked: true},
      uploads_w: {checked: false, locked: false}
  }
end

def sc_user_definitions
  {
      schemes_r: {checked: false, locked: true},
      schemes_w: {checked: false, locked: true},
      schemes_e: {checked: false, locked: true},
      schemes_d: {checked: false, locked: true},

      sc_users_r: {checked: false, locked: true},
      sc_users_w: {checked: false, locked: true},
      sc_users_e: {checked: false, locked: true},
      sc_users_d: {checked: false, locked: true},

      co_users_r: {checked: true, locked: true},
      co_users_w: {checked: false, locked: false},
      co_users_e: {checked: false, locked: false},
      co_users_d: {checked: false, locked: false},

      businesses_r: {checked: true, locked: true},
      businesses_e: {checked: false, locked: false},
      businesses_w: {checked: false, locked: true},
      businesses_d: {checked: false, locked: true},
      uploads_r: {checked: false, locked: false},
      uploads_w: {checked: false, locked: false}
  }
end
