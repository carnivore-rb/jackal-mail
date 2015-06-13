require 'jackal-mail'
require 'pry'

SRC_ADDR = 'foo@example.com'
DST_ADDR = 'bar@example.com'
SUBJECT  = 'test'
BODY     = 'foo'

class Jackal::Mail::Smtp
  def send_mail(payload, args)
    payload.set(:smtp_args, args)
    h = { :from => args[:from], :to => args[:to], :subject => args[:subject] }
    Mail::Message.new(h)
  end
end

describe Jackal::Mail::Smtp do

  before do
    @runner = run_setup(:test)
    track_execution(Jackal::Mail::Smtp)
  end

  after do
    @runner.terminate if @runner && @runner.alive?
  end

  let(:notification) { Carnivore::Supervisor.supervisor[:jackal_mail_input] }

  describe 'execute' do
    it 'fails to execute if missing expected payload data' do
      payload = Jackal::Utils.new_payload(:test, {})
      result = transmit_and_wait(notification, payload)
      callback_executed?(result).must_equal false
    end

    it 'passes correct data/format to slack-notifier' do
      result = transmit_and_wait(notification, mail_payload)
      callback_executed?(result).must_equal true
      # ensure payload result was cleared to allow for multiple runs
      result.get(:data, :mail, :result).must_be_nil

      arr = [[:to, [DST_ADDR]], [:from, SRC_ADDR], [:subject, SUBJECT], [:body, BODY]]
      arr.each { |key, value| result[:smtp_args][key].must_equal value }
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
