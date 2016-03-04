require 'test_helper'

<% module_namespacing do -%>
describe <%= class_name %>Job do
  around { |test| Sidekiq::Testing.inline!(&test) }
end
<% end -%>
