require 'test_helper'

<% module_namespacing do -%>
describe <%= class_name %>Controller do
<% if actions.empty? -%>
<% else -%>
<% actions.each do |action| -%>
  it 'should get <%= action %>' do
    get :<%= action %>
    value(response).must_be :success?
  end
<% end -%>
<% end -%>
end
<% end -%>
