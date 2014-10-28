require 'jackal-mail'

=begin
      # In payload: notification_email
      {
        :destination => {
          :email => '',
          :name => ''
        },
        :origin => {
          :email => '',
          :name => ''
        },
        :subject => '',
        :message => '',
        :html => true/false
      }
=end

module Jackal
  # Mailer component
  module Mail
    # Send mail via SMTP
    class Smtp < Jackal::Callback

      # Setup the callback
      def setup(*_)
        require 'pony'
      end

      # Check validity of message
      #
      # @param message [Carnivore::Message]
      # @return [Truthy, Falsey]
      def valid?(message)
        super do |payload|
          payload.get(:data, :notification_email)
        end
      end

      # Process message and send email
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |payload|
          deliver(payload)
          job_completed(:mail, payload, message)
        end
      end

      # Deliver mail notification via smtp based on payload contents
      #
      # @param payload [Smash]
      def deliver(payload)
        payload_conf = payload[:data][:notification_email]
        begin
          via_options = payload_conf.fetch(:via_options, config.fetch(:via_options, {}))
          via_options = Hash[
            via_options.map do |k,v|
              [k.to_sym, v]
            end
          ]
          args = {
            :to => [payload_conf[:destination]].flatten(1).map{|d| d[:email]},
            :from => payload_conf[:origin][:email],
            :subject => payload_conf[:subject],
            :via => :smtp,
            :via_options => via_options
          }
          if(payload_conf[:attachments])
            args[:attachments] = Hash[*payload_conf[:attachments].map{|k,v|[k.to_s,v]}.flatten(1)]
          end
          message_key = payload_conf[:html] ? :html_body : :body
          args[message_key] = payload_conf[:message]
          if(args[:via_options][:authentication])
            args[:via_options][:authentication] = args[:via_options][:authentication].to_s.to_sym
          end
          if(bcc = config.get(:bcc))
            args[:bcc] = bcc
          end
          result = Pony.mail(args)
          payload.set(:data, :mail, :result, result)
          debug "Pony delivery result: #{result.inspect}"
        rescue => e
          error "Delivery failed: #{e.class} - #{e}"
          debug "#{e.class}: #{e}\n#{e.backtrace.join("\n")}"
        end
      end

    end
  end
end
