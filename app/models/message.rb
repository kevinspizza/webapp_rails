require 'net/imap'
require 'mail'
require 'mailman'

class Message
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :subject, type: String
  field :sender, type: String
  field :content, type: String
  field :date, type: String
  field :user_id, type: Moped

  belongs_to :user

  def self.validate_account(user)
    init_account(user)
    Mail.first
    rescue Net::IMAP::NoResponseError
      return false
    return true
  end

  private

    def self.retrieve_mails(user)
      user = User.where(:_id => user).first
      init_account(user) # first download
      allmail = Mail.all
      allmail.each do |mail|
        save_to_db(mail, user)
      end
    end
  
    def self.init_account(user)
      port_server = user.port_server.blank? ? "143" : user.port_server
      Mail.defaults do
        retriever_method :imap, :address    => user.imap_server,
                          :port       => port_server,
                          :user_name  => user.email,
                          :password   => user.password,
                          :enable_ssl => false
      end
      return 
    end
  
    def self.save_to_db(mail, user)
      if (mail.multipart?)            #multipart mail
        body = mail.html_part
        if (body == nil)              #type of email
          body = mail.text_part
        end
      else
        body = mail.body
      end
      if body
        body = body.decoded.html_safe
        body = body.encode('UTF-8', :invalid => :replace, :undef => :replace) unless body.encoding.name == 'UTF-8'
      end
      if (!Message.where(:_id => mail.message_id.to_s.scan(/\d/).join('')).exists?) #if doesn't exists then save
        if mail
          sender = (mail.from) ? ((mail.from.is_a?(Array)) ? mail.from[0].to_s : mail.from.to_s) : "Could not parse sender"
          subject = (mail.subject == nil) ? "Could not parse subject" : mail.subject.to_s
          Message.create(:subject => subject.force_encoding("UTF-8"), :sender => sender.force_encoding("UTF-8"), 
                         :content => body, :date => mail.date.to_s, 
                         :user_id => user.id, :_id => mail.message_id.to_s.scan(/\d/).join(''))
        end
      end
    end
end
