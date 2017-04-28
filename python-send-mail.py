# Settings

SMTP_SERVER = 'localhost'
SMTP_PORT = 25
SMTP_USERNAME = 'username'
SMTP_PASSWORD = 'secret'
SMTP_FROM = 'from@domain.com'
SMTP_TO = 'to@domain.com'

TEXT_FILENAME = '/path/to/attachment.txt'
MESSAGE = """This is the message
to be sent to the client.
"""

# Now construct the message
import smtplib, email
from email import encoders
import os

msg = email.MIMEMultipart.MIMEMultipart()
body = email.MIMEText.MIMEText(MESSAGE)
attachment = email.MIMEBase.MIMEBase('text', 'plain')
attachment.set_payload(open(TEXT_FILENAME).read())
attachment.add_header('Content-Disposition', 'attachment', filename=os.path.basename(TEXT_FILENAME))
encoders.encode_base64(attachment)
msg.attach(body)
msg.attach(attachment)
msg.add_header('From', SMTP_FROM)
msg.add_header('To', SMTP_TO)

# Now send the message
mailer = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
# EDIT: mailer is already connected
# mailer.connect()
mailer.login(SMTP_USERNAME, SMTP_PASSWORD)
mailer.sendmail(SMTP_FROM, [SMTP_TO], msg.as_string())
mailer.close()
