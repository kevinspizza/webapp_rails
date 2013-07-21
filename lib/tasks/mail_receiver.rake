desc "Receive mails"
task :receive_mails => :environment do
	Message.retrieve_mails(ENV["USER_DATA"])
end