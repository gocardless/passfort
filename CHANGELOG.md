Changelog
=========

Unreleased
----------

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
