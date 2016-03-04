require 'test_helper'

<% module_namespacing do -%>
describe <%= class_name %> do
  let(:<%= file_name %>) { build(:<%= class_name.underscore.tr('/', '_') %>) }

  it "must be valid" do
    value(<%= file_name %>).must_be :valid?
  end
end
<% end -%>
