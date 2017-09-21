require 'sinatra'
require "sinatra/reloader" if development?

require "twilio-ruby"

configure :development do
  require 'dotenv'
  Dotenv.load
end


enable :sessions


@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]


get "/sms/incoming" do
  session["last_intent"] ||= nil

  session["counter"] ||= 1
  count = session["counter"]

  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip

  message = ""
  media = nil

  if body == "hi"
    message = "Hi, I'm MYbot. I can answer basic questions about Mengyang, who developed me."
  elsif body == "birthday"
    message = "Mengyang's birthday is May 24th"
  elsif body == "what"
    message = "I am a simple bot. I can only answer basic questions about Mengyang :P"
  elsif body == "age"
    message = "You are rude! You shouldn't ask this question!"
  elsif body == "eat"
    message = "Mengyang is a foodie! She loves to eat almost everything :D"
  elsif body == "sports"
    message = "hmmm Mengyang is not a big fan of sports!"
  elsif body == "bye"
    message = "Bye! Talk to me again!"
  end


  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|
      m.body( message)
      unless media.nil?
        m.media(media)
      end
   end
  end

  content_type 'text/xml'
  twiml.to_s

end
