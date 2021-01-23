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

Integrating rux into your Rails app is pretty straightforward.

1. Add rux-rails to your Gemfile, eg:
    ```ruby
    gem 'rux-rails', '~> 1.0'
    ```
1. Run `bundle install`
1. ... that's it.

Now any file with a .rux extension your Rails app loads (i.e. `require`s) will get transparently transpiled and loaded.

### Development Environment

By default, rux-rails will automatically transpile .rux files on load in the development and test environments only. In addition, any changes you make to your .rux files will get picked up without having to restart your Rails server, much the same way changes to controllers, etc are handled. You can manually enable or disable automatic transpilation per-environment.

For example, to disable it in development, add the following line to your config/environments/development.rb file:

```ruby
config.rux.transpile = false
```

### Production Environment

By default, automatic transpilation of .rux files is disabled in the production environment for the same reasons the asset pipeline is disabled. Your view components (and static assets) don't change once deployed, so it's more efficient to precompile (or pre-transpile) them before deploying. Rux-rails comes with a handy rake task that can pre-transpile all your .rux templates:

```bash
bundle exec rake rux:transpile
```

I recommend running this rake task at the same time you run `assets:precompile` and/or `webpacker:compile`. The `rux:transpile` task will produce one .ruxc file for every .rux file it encounters in your app.

## Writing Rux Components

Rux components are just view components that contain rux tags. As with HTML, rux tags can be nested inside one another and can contain Ruby control structures, etc.

Components usually live in the app/components directory. Just as is possible with models, controllers, etc, it's possible to organize your view components into subdirectories as your application design warrants.

Let's take a look at two simple components. The first renders a first and last name, while the second uses the first to compose a greeting:

```ruby
# app/components/name_component.rux
class NameComponent < ViewComponent::Base
  def initialize(first_name:, last_name:)
    @first_name = first_name
    @last_name = last_name
  end

  def call
    <span>{@first_name} {@last_name}</span>
  end
end

# app/components/greeting_component.rux
class GreetingComponent < ViewComponent::Base
  def call
    <div>
      Hey there <NameComponent first-name="Homer" last-name="Simpson" />!
    </div>
  end
end
```

Then, in one of your Rails views, render `GreetingComponent` like so:

```html+erb
<%# app/views/home/index.html.erb %>
<%= render(GreetingComponent.new) %>
```

When rendered, the view will contain the following HTML:

```html
<div>
  Hey there <span>Homer Simpson!</span>
</div>
```

### Embedding Ruby

## Rux Templates

## How it Works

## Running Tests

`bundle exec rspec` should do the trick.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
