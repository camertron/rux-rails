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

1. Add rux-rails to the development group in your Gemfile, eg:
    ```ruby
    group :development do
      gem 'rux-rails', '~> 1.0'
    end
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

By including rux-rails in the `:development` group in your Gemfile, rux-rails and its monkeypatches to `Kernel` aren't loaded in production (which is a good thing). You could choose to include rux-rails in the default group, but automatic transpilation of .rux files is disabled in the production environment for the same reasons the asset pipeline is disabled. Your view components (and static assets) don't change once deployed, so it's more efficient to precompile (or pre-transpile) them before deploying. Rux-rails comes with a handy rake task that can pre-transpile all your .rux templates:

```bash
bundle exec rake rux:transpile
```

I recommend running this rake task at the same time you run `assets:precompile` and/or `webpacker:compile`. The `rux:transpile` task will produce one .rb file for every .rux file it encounters in your app.

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
    <span class='name'>{@first_name} {@last_name}</span>
  end
end

# app/components/greeting_component.rux
class GreetingComponent < ViewComponent::Base
  def call
    <div class='greeting'>
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
<div class="greeting">
  Hey there <span class="name">Homer Simpson!</span>
</div>
```

### Component Contents

View components can also have content bodies, which can be other view components. Use the `content` method  where you want the nested content to be rendered. As an example, let's modify our `GreetingComponent`:


```ruby
# app/components/greeting_component.rux
class GreetingComponent < ViewComponent::Base
  def call
    <div class='greeting'>
      <SalutationComponent>
        <NameComponent first-name="Homer" last-name="Simpson" />
      </SalutationComponent>
    </div>
  end
end

# app/components/salutation_component.rux
class SalutationComponent < ViewComponent::Base
  SALUTATIONS = ['Hey there', 'Greetings', 'Great to see you'].freeze

  def call
    <span class='salutation'>
      {SALUTATIONS.sample} {content}!
    </span>
  end
end
```

When rendered in a view, we get the following HTML:

```html
<div class="greeting">
  <span class="salutation">
    Greetings <span class="name">Homer Simpson</span>!
  </span>
</div>
```

### Embedding Ruby

As we've already seen, you can embed Ruby code between curly braces. It's important to know however that Ruby code is only allowed for attribute values and content bodies.

Because the wide world of Ruby is available to you, anything goes. For example, let's modify our `GreetingComponent` to say hi to a variable number of people:

```ruby
# app/components/greeting_component.rux
class GreetingComponent < ViewComponent::Base
  def initialize(people:)
    @people = people
  end

  def call
    <div class='greeting'>
      {@people.map do |person|
        <SalutationComponent>
          Hey there <NameComponent
            first-name={person[:first_name]}
            last-name={person[:last_name]}
          />!
        </SalutationComponent>
      end}
    </div>
  end
end
```

Notice I used `map` to render multiple `NameComponents`. I've got rux in my Ruby in my rux in my Ruby!

Next, let's modify our view to pass in an array of person hashes:

```html+erb
<%# app/views/home/index.html.erb %>
<%= render(
  GreetingComponent.new([
    { first_name: 'Homer',  last_name: 'Simpson' },
    { first_name: 'Barney', last_name: 'Gumble' },
    { first_name: 'Monty',  last_name: 'Burns' }
  ])
) %>
```

This results in the following HTML:

```html
<div class="greeting">
  <span class="salutation">
    Greetings <span class="name">Homer Simpson</span>!
  </span>
  <span class="salutation">
    Great to see you <span class="name">Barney Gumble</span>!
  </span>
  <span class="salutation">
    Hey there <span class="name">Monty Burns</span>!
  </span>
</div>
```

## Rux Templates

In addition to supporting view components, rux also supports rendering rux directly in your Rails views. Just give your view a .ruxt file extension and voila! Rux in your views! As an example, let's rewrite our view from the previous section as a rux template:

```ruby
# app/views/home/index.html.ruxt
<GreetingComponent
  people={[
    { first_name: 'Homer',  last_name: 'Simpson' },
    { first_name: 'Barney', last_name: 'Gumble' },
    { first_name: 'Monty',  last_name: 'Burns' }
  ]}
/>
```

## How it Works

Rux-rails monkeypatches the `Kernel` module in order to automatically transpile .rux files on `require`. That might be a controversial idea, but it seems to work really well. Here's how it works step-by-step:

1. First, rux-rails attempts to call Ruby's original `require` method.
1. If original `require` raises a `LoadError`, rux-rails searches the Ruby load path for a file with a .rux extension.
1. If a corresponding .rux file exists on disk, rux-rails compiles it loads it using `Kernel.load`.
1. If a corresponding .rux file cannot be found, rux-rails raises the original `LoadError`.

There are also monkeypatches in place for Zeitwerk and `ActiveSupport::Dependencies` to get auto-transpiling working with Rails autoloading (which is absurdly obtuse and complicated). The monkeypatches are necessary mostly because Ruby and Rails assume Ruby files will always have .rb file extensions.

Hit me up if you know of a less invasive way of enabling auto-transpilation.

## Editor Support

Sublime Text: [https://github.com/camertron/rux-SublimeText](https://github.com/camertron/rux-SublimeText)

Atom: [https://github.com/camertron/rux-atom](https://github.com/camertron/rux-atom)

VSCode: [https://github.com/camertron/rux-vscode](https://github.com/camertron/rux-vscode)

## Running Tests

`bundle exec appraisal rake` should do the trick.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
