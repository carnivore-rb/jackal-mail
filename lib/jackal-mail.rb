require 'jackal'
require 'jackal-mail/version'

module Jackal
  module Mail
    autoload :Smtp, 'jackal-mail/smtp'
  end
end

Jackal.service(
  :mail,
  :description => 'Send mail notification',
  :category => :notifier,
  :configuration => {
    :via_options => {
      :type => :hash,
      :description => 'SMTP configuration options'
    },
    :bcc => {
      :type => :string,
      :description => 'BCC address for all mail'
    }
  }
)
