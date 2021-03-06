Changelog
=========

Unreleased
----------

No changes.

0.4.2
-----

- Add Rails 6 compatibility

0.4.1
-----

- Treat Bad Gateway (502) errors separately

0.4.0
-----

- Add `company_search` functionality

0.3.1
-----

- Allow setting connection properties

0.3.0
-----

- Add `ActiveSupport::Notifications` support.

0.2.3
-----

- Raise `Passfort::Errors::TimeoutError` when a request times out.

0.2.2
----------

- Raise UnparsesableResponseError when the response cannot be parsed as JSON.

0.2.1
-----

- Include detailed error information in any raised errors.

0.2.0
-----

- Convert resource attributes to a hash with indifferent access,
  so that you can use symbol or string keys.
