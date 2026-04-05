class UserMailer < ApplicationMailer
  default from :'bingzhe923@gmail.com' # the single verified email in SendGrid

  def password_reset_code(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: "Your PassWord Reset Code")
  end
end
