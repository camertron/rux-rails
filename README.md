## rux-rails [![Build Status](https://travis-ci.com/camertron/rux-rails.svg?branch=master)](https://travis-ci.com/camertron/rux-rails)

Easily write [rux](https://github.com/camertron/rux) view components in Rails.

## View Components

If you haven't already, head over to [viewcomponent.org](https://viewcomponent.org/) or watch Joel Hawksley's excellent 2019 [Railsconf talk](https://www.youtube.com/watch?v=y5Z5a6QdA-M) on writing view components before reading the rest of this README.

## What's Rux?

View components are awesome, but they're a little cumbersome to work with. The view itself is a separate file, and you have to write a bunch of `render` statements all over the place. What if you could write HTML directly inside your view components like some fancy Javascript dev?

Well now you can! [Rux](https://github.com/camertron/rux) makes it possible to write HTML tags and render components _inside_ your view component classes, and rux-rails brings that goodness to Rails.

## An Example

Let's take a look at one iteration of Joel's issue badge example. The original code looks like this:

```ruby
module Issues
  class Badge < ViewComponent::Base
    include OcticonsHelper

    def initialize(issue:)
      @issue = issue
    end

    def template
      <<~erb
      <% if @issue.closed? %>
        <%= render Primer::State, color: :red, title: "Status: Closed" do %>
          <%= octicon('issue-closed') %> Closed
        <% end %>
      <% else %>
        <%= render Primer::State, color: :green, title: "Status: Open" do %>
          <%= octicon('issue-opened') Open %>
        <% end %>
      <% end %>
      erb
    end
  end
end
```

Here's the equivalent written in rux (sorry about the syntax highlighting - Github doesn't know about rux yet):

```ruby
module Issues
  class Badge < ViewComponent::Base
    include OcticonsHelper

    def initialize(issue:)
      @issue = issue
    end

    def call
      if @issue.closed?
        <Primer::State color={:red} title="Status: Closed">
          {octicon('issue-closed')} Closed
        </Primer::State>
      else
        <Primer::State color={:green}, title="Status: Open">
          {octicon('issue-opened')} Open
        </Primer::State>
      end
    end
  end
end
```

In my humble opinion, the rux version:

1. is easier to read without all the ERB syntax.
1. makes the connection between Ruby and HTML more obvious.
1. allows embedding Ruby more naturally with curly braces.
1. makes `render` calls implicit.

## Getting Started

## Writing Rux Tags

## Embedding Ruby

## Rux Templates

## How it Works

## Running Tests

`bundle exec rspec` should do the trick.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
