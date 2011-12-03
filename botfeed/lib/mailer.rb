# como configurar action mailer ?
# http://guides.rubyonrails.org/action_mailer_basics.html

ActionMailer::Base.smtp_settings = {
  :address              => CONFIG['mailer']['smtp_settings']['address'],
  :port                 => CONFIG['mailer']['smtp_settings']['port'],
  :user_name            => CONFIG['mailer']['smtp_settings']['user_name'],
  :password             => CONFIG['mailer']['smtp_settings']['password'],
  :authentication       => CONFIG['mailer']['smtp_settings']['authentication'],
  :enable_starttls_auto => CONFIG['mailer']['smtp_settings']['enable_starttls_auto']  }
  
if CONFIG['mailer']['delivery_method'] == 'test'
  ActionMailer::Base.delivery_method = :test 
  LOG.info "Mailer in Test mode"
end

class Mailer < ActionMailer::Base
  # envia una notificacion generica
  def notification(txt,ops = { :to => CONFIG['mailer']['mail_to'], :subj => 'Nueva Notificacion', :sender => 'bot@multicaja.cl'})
    recipients  ops[:to]
    from        ops[:sender]
    subject     ops[:subj]
    body        ''+txt
    #LOG.info "Enviando correo = #{txt}"

    # asi se podrian adjuntar archivos
    #set up the attachment
    #attachment  :content_type => content_type,
    #            :body         => File.read(file_name),
    #            :filename     => file_name.gsub(/.*\//,'')
  end
end
