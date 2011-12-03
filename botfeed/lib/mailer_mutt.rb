class Mailer
  
  # recipientes separados por coma ej: 'mail1@aaa.com, mail2@aaa.com'
  def initialize recipients, subject, body
    @recipients = recipients
    @subject = subject
    @body = body
  end
  
  def deliver
    mutt_path = CONFIG['mailer']['mutt_path'] || "/usr/bin/mutt"
    #usando mutt desde shell: echo "body" | mutt -s 'subject' user@mail.com
    LOG.info 'Enviando mail con Mutt'
    LOG.info `echo "#{@body}" | #{mutt_path} -s "#{@subject}" -c #{@recipients}`
    LOG.info 'Se termino de enviar mail con Mutt'
  end
  
  def self.notification(txt,ops = { :to => CONFIG['mailer']['mail_to'], :subj => 'Nueva Notificacion'})
    if ops[:sender]
      raise "mutt no deja cambiar from del mail, para hacerlo hay que cambiar 'set from' del archivo .muttrc"
    end
    Mailer.new ops[:to], ops[:subj], txt 
  end
  
end
