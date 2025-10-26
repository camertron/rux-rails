## 2.0.0
* Remove the `Image`, `Audio`, and `Video` components (was anyone actually using these?)
* Remove support for Rails 6.1 and 6.0.
* Upgrade to onload v1.1 and rux to v1.3.
  - Add `config.rux.ignore_path` to Rails config for controlling which ignore file should be populated with generated paths.
* Add a series of Rails helper components:
  - `Rails::ButtonTo`
  - `Rails::LinkTo`
  - `Rails::ContentTag`
  - `Rails::FormWith`
  - `Rails::Label`
  - `Rails::Button`
  - `Rails::HiddenField`
  - `Rails::PasswordField`
  - `Rails::TextField`
* Add the `Rux::Component` component for rendering component instances.
  - Eg: `<Rux::Component instance={@child} />`.

## 1.5.0
* Extract monkeypatches into the [onload gem](https://github.com/camertron/onload).
* Upgrade to rux v1.2.
* Drop official support for Rails < 6 and Ruby < 3.

## 1.4.0
* Make rux-rails safe to load in production.
  - All the monkeypatches to `Kernel`, etc are now only loaded if `config.rux.transpile` is `true`.

## 1.3.0
* Add support for view_component v3.0.

## 1.2.2
* Fix calling private Zeitwerk method.
* Check railties version in dummy app instead of rails.

## 1.2.1
* Support newer versions of Zeitwerk (2.5 and beyond).
* Support Rails 7.

## 1.2.0
* Require ext patches in railtie to take advantage of Rails' `config.autoloader` setting.
  - This should fix Rails setups in which Zeitwerk is part of the Gemfile but `config.autoloader` is set to `:classic` (previously rux-rails relied on attempting to `require` zeitwerk and `rescue`ing the possible `LoadError`).

## 1.1.0
* Add `ActiveSupport::SafeBuffer` subclass to handle arrays (#1, @jaredcwhite)

## 1.0.0
* Birthday!
