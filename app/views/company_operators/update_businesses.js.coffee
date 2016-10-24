$("#business_select").empty().append("<%= escape_javascript(render(:partial => '/partials/business',locals: {businesses: @businesses } )) %>")
