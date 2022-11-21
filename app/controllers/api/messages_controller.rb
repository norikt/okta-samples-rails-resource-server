class Api::MessagesController < ApplicationController
  def index
    messages = [
      { date: Time.current, text: 'I am a robot.' },
      { date: 1.minute.ago, text: 'Hello, world!' }
    ]
    render json: { messages: messages }.to_json, status: :ok
  end
end
