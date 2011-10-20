Logic for sign up panels

Sign Up form
Show if no user signed in
and no user for shop


Verify
Show if no user signed in
and user for shop


Select plan
Show if user signed in
and user has no plan


Show plan
Show if user signed in
and user has plan

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




DAMMIT.

OK. So what's the issue? The issue is we need a controller that changes the plan for a user.

We've got a user. This always exists. And we've got a few different plans to select from.

So really what we need is a user controller. But because of the way devise works, if we make this, we might cause conflicts and problems.

So let's try creating a shop resource above devise, but only for the update_plan action.

This isn't ideal now we need to integrate it with paypal.

So we'll create a form with nested attributes.

We have:

User has a subscription which belongs to a plan.

What do we need? Let's forget making the default that the user has no subscription for now.

No, let's keep that in in fact.


