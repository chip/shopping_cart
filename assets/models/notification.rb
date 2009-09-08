class Notification < ActionMailer::Base

  def order(order, sent_at = Time.now)
    subject    'Notification#order'
    recipients 'you@example.com'
    from       'no-reply@example.com'
    sent_on    sent_at
    body       :order => order
  end

end
