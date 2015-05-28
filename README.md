# Jackal Mail

Simple handler for sending email

## Configuration
Optional configuration

```json
{ "jackal": {
    "config": {
        "mail": {
            "bcc": "",
            "via_options": { ... } }}}}
```
See https://github.com/benprew/pony#transport for "via_options"

## Payload structure

```ruby
{ :destination => {
    :email => '',
    :name => '' },

  :origin => {
    :email => '',
    :name => '' },

  :subject => '',
  :message => '',
  :html => true/false }
```
