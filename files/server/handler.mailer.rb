#!/usr/bin/env ruby
#
# Sensu Mail Handler
#
# This handler reports alerts to a specified mail-address.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'mail'
require 'timeout'

class Mailer < Sensu::Handler
  def short_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def action_to_string
   @event['action'].eql?('resolve') ? "RESOLVED" : "ALERT"
  end

  def handle
    params = {
      :mail_to   => settings['mailer']['mail_to'],
      :mail_from => settings['mailer']['mail_from'],
    }

    body = "#{@event['check']['output']}"
    subject = "#{action_to_string} - #{short_name}: #{@event['check']['notification']}"

    Mail.defaults do
      delivery_method :smtp, { :openssl_verify_mode => 'none' }
    end

    begin
      timeout 10 do
        Mail.deliver do
          to      params[:mail_to]
          from    params[:mail_from]
          subject subject
          body    body
        end

        puts 'mailer -- sent alert for ' + short_name + ' to ' + params[:mail_to]
      end
    rescue Timeout::Error
      puts 'mailer -- timed out while attempting to ' + @event['action'] + ' an incident -- ' + short_name
    end
  end
end
