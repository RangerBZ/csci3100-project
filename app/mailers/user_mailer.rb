class UserMailer < ApplicationMailer
  default from: "bingzhe28@hotmail.com" # the single verified email in SendGrid

  def password_reset_code(user, code)
    @user = user
    @code = code
    
    send_via_sendgrid_api
    
  end

  def daily_report(user, new_items, favorite_items)
    @user = user
    @new_items = new_items
    @favorite_items = favorite_items
    mail(to: user.email, subject: 'Daily Trade Report on CampusTrade')
  end
  
  private
  
  def send_via_sendgrid_api
    return unless @user && @user.email
    

    from_email = "bingzhe28@hotmail.com"  # or: self.class.default[:from]
    
    from = SendGrid::Email.new(email: from_email)
    to = SendGrid::Email.new(email: @user.email)
    subject = "Your Password Reset Code"
    Rails.logger.info "Here we get: #{@code}"
    
    html_content = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
          .content { padding: 30px; background: #f9f9f9; border: 1px solid #ddd; }
          .code-box { 
            font-size: 36px; 
            font-weight: bold; 
            color: #4CAF50; 
            text-align: center; 
            padding: 25px; 
            background: white; 
            border: 3px dashed #4CAF50;
            margin: 25px 0;
            letter-spacing: 5px;
            border-radius: 8px;
          }
          .footer { text-align: center; color: #999; font-size: 12px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; }
        </style>
      </head>
      <body>
        <div class="header">
          <h1>🔐 Password Reset</h1>
        </div>
        <div class="content">
          <p>Hi <strong>#{@user.name || @user.email}</strong>,</p>
          <p>You requested a password reset. Here's your verification code:</p>
          
          <div class="code-box">
            #{@code}
          </div>
          
          <p><strong>⚠️ This code will expire in 1 hour.</strong></p>
          <p>If you didn't request this password reset, please ignore this email or contact support if you have concerns.</p>
          
          <p>Best regards,<br><strong>CampusTrade Team</strong></p>
        </div>
        <div class="footer">
          <p>&copy; #{Date.today.year} CampusTrade. All rights reserved.</p>
          <p>This is an automated message, please do not reply directly to this email.</p>
        </div>
      </body>
      </html>
    HTML
    
    # Create plain text content
    text_content = <<~TEXT
      Password Reset Verification Code
      
      Hi #{@user.name || @user.email},
      
      You requested a password reset. Here's your verification code:
      
      #{@code}
      
      This code will expire in 1 hour.
      
      If you didn't request this password reset, please ignore this email.
      
      Best regards,
      CampusTrade Team
      
      © #{Date.today.year} CampusTrade. All rights reserved.
    TEXT
    
    # ✅ FIX: Add plain text FIRST, then HTML
    content = SendGrid::Content.new(type: 'text/plain', value: text_content.strip)
    mail_obj = SendGrid::Mail.new(from, subject, to, content)
    mail_obj.add_content(SendGrid::Content.new(type: 'text/html', value: html_content.strip))
    
    # Send via SendGrid API
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail_obj.to_json)
    
    # Rails.logger.info "SendGrid Response Status: #{response.status_code}"
    # Rails.logger.info "SendGrid Response Body: #{response.body}"

    unless response.status_code == '202'
      # Rails.logger.error "❌ SendGrid failed with status: #{response.status_code}"
      raise "Failed to send email via SendGrid (Status: #{response.status_code})"
    end
    
    response
  end
 
end
