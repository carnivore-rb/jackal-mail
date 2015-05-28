require 'jackal-mail'
require 'pry'

SRC_ADDR = 'foo@example.com'
DST_ADDR = 'bar@example.com'
SUBJECT  = 'test'
BODY     = 'foo'

class Jackal::Mail::Smtp
  def send_mail(args)
    $args = args
    h = { :from => args[:from], :to => args[:to], :subject => args[:subject] }
    Mail::Message.new(h)
  end
end

describe Jackal::Mail::Smtp do

  before do
    @runner = run_setup(:test)
  end

  after do
    @runner.terminate if @runner && @runner.alive?
  end

  let(:notification) { Carnivore::Supervisor.supervisor[:jackal_mail_input] }

  describe 'execute' do
    it 'passes correct data/format to slack-notifier' do
      notification.transmit(mail_payload)
      source_wait { !MessageStore.messages.empty? }
      result = MessageStore.messages.first

      (!!result).must_equal true
      arr = [[:to, [DST_ADDR]], [:from, SRC_ADDR], [:subject, SUBJECT], [:body, BODY]]
      arr.each { |key, value| $args[key].must_equal value }
    end
  end

  private

  def mail_payload
    h = { :notification_email => {
            :destination => { :email => DST_ADDR },
            :origin => { :email => SRC_ADDR },
            :subject => SUBJECT,
            :message => BODY,
            :html => false }}
    Jackal::Utils.new_payload(:test, h)
  end

end
