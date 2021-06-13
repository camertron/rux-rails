## 1.2.0
* Require ext patches in railtie to take advantage of Rails' `config.autoloader` setting.
  - This should fix Rails setups in which Zeitwerk is part of the Gemfile but `config.autoloader` is set to `:classic` (previously rux-rails relied on attempting to `require` zeitwerk and `rescue`ing the possible `LoadError`).

## 1.1.0
* Add `ActiveSupport::SafeBuffer` subclass to handle arrays (#1, @jaredcwhite)

## 1.0.0
* Birthday!
