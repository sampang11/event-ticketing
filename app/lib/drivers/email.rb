require 'sendgrid-ruby'

module Drivers
  module Email
    include SendGrid

    def ticket_email(participant)
      from_email = 'sujit@brokrete.com'
      from_name = 'Druk Canada'
      from = SendGrid::Email.new(email: from_email, name: from_name)

      to_email = participant.email
      to_name = participant.full_name
      to = SendGrid::Email.new(email: to_email, name: to_name)
      subject = 'Druk Canada Gala Registration Approved!'

      mail = SendGrid::Mail.new(from, subject, to, Content.new(type: 'text/plain', value: 'hi this is a test email'))
      mail.add_content Content.new(type: 'text/html', value: content_body(participant))

      pdf_attachment = attachment(participant)
      mail.add_attachment(pdf_attachment)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
    end

    def content_body(participant)
      "<h1>Registration Approved!</h1><p>Thank you #{participant.full_name} for the registration. Please find the attached e-ticket in this mail.</p>"
    end

    def attachment(participant)
      attachment = SendGrid::Attachment.new
      eticket = Pdf::EticketPdf.new(participant: participant)
      eticket.build
      attachment.content = Base64.strict_encode64(eticket.render)
      attachment.type = 'application/pdf'
      attachment.filename = 'eticket.pdf'
      attachment.disposition = 'attachment'

      attachment
    end

  end
end
