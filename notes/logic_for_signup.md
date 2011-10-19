Logic for sign up panels

Sign Up form
Show if no user for shop


Verify
Show if user hasn't been verified


Select plan
Show if user for shop and user has no plan


Show plan
Show if user has been verified and has a subscription

Show logout/change email address
Show if a user is signed in


We could have a "user status" variable

On shop show, we do some rails logic to determine user status
This user status gets loaded into a jquery variable. 
Maybe not actually needed? Because when we do an AJAX request, we're returning the status anyway. i.e. if we


Maybe we show all fields and hide the fields using jquery then we've got one lot of code to update the visibility of stuff?

Or we just initialise the display properties on load



Problem - to do a rails generated form for show plan or select plan, we need to actually have a plan first.

Since we don't have a plan when the screen is shown, even if we have a user, Rails will give us an error.

To get around this, we could use the accepts_nested_attributes_for :subscription


<% form_for @user do |f| %>
  <%= f.error_messages %>
  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :plan_id, "Select Plan" %><br />
    <%= f.select(:plan_id, [["Business", 1], ["Personal", 2]], {:include_blank => 'None'}) %>
  </p>
  <p><%= f.submit "Submit" %></p>
<% end %>