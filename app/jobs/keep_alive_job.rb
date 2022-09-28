#Keeps Redis Cloud Alive.  Just an empty job, but makes RedisCloud think there's activity.
class KeepAliveJob < ApplicationJob
  queue_as :default

  def perform(id)
    puts id
  end
end