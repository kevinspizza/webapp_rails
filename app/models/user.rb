class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :imap_server, type: String
  field :port_server, type: Integer

  has_many :messages, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 20 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password,  :presence => true,
                        :length => { :minimum => 4 },
                        :confirmation => true
  validates :imap_server, :presence => true

  def self.authenticate(email, password)
  	user = User.where(:email => email).first
  	if (user && user.password == password)
  		return user
  	end
  end

  def self.authenticate_session(id_to_check)
  	user = User.where(:id => id_to_check).first
  	self.authenticate(user.email, user.password)
  end

end
