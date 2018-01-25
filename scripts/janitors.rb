require 'sidekiq'

class RawMessageImporter
  include Sidekiq::Worker

  def perform
    puts 'wfp'
  end
end
