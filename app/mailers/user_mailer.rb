class UserMailer < ApplicationMailer
  def invite(user, inviter, world)
    @inviter = inviter
    @world = world
    mail(to: user, subject: 'You\'ve been invited to Kronografi')
  end
  
  def collaborating(user, inviter, world)
    @inviter = inviter
    @world = world
    mail(to: user.email, subject: 'You\'ve been added as a collaborator on Kronografi')
  end
end
