# # require_relative './schemes'
# binding.pry
# FactoryGirl.define do
#   factory :scheme_operator do
#     email 'jennifer@back_to_the_future.com'
#     name 'Jennifer'
#     password 'mypassword'
#     confirmed_at DateTime.now
#     association :scheme, factory: :scheme, name: 'test scheme', scheme_country_
#
#     factory :scheme_operator_with_director do
#       after(:create) do |sc_director|
#         sc_director.sc_director!
#         sc_director.remove_role :sc_user
#
#         PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
#           sc_director.add_role permission if has[:checked]
#         end
#       end
#     end
#   end
# end
