require 'resque'
require 'resque/server'
require 'resque-job-stats/server'

# Extends Resque Web Based UI.
# Structure has been borrowed from ResqueScheduler.
module BRGSResque
  module Server

    def self.erb_path(filename)
      File.expand_path("../views/#{filename}", __FILE__)
    end

    def self.included(base)
      base.class_eval do

        post '/admission' do
          BRGS.admission 'paper', params['rdf-uri']
        end

        put '/spider' do
          BRGS.spider 'paper'
        end

        get '/node_query.json' do
          content_type :json
          if params.key? :q
            status 400
            return {:error => 'must specify query parameter ?q=xxx'}.to_json
          end

          paths = BRGS.node_query params[:q]
          {:q => params[:q], :paths => paths}.to_json
        end

        get '/path/:path_index' do
          PrintUtils.path params[:path_index]
        end

        get '/brgs' do
          stats_view('stats')
        end
        
        get '/brgs.poll' do
          @polling = true
          stats_view('stats', {:layout => false})
        end

        helpers do
          def stats_view(filename, options = {}, locals = {})
            erb(File.read(BRGSResque::Server.erb_path("#{filename}.html.erb")), options, locals)
          end
          
          def stats_poll
            if @polling
              text = "Last Updated: #{Time.now.strftime("%H:%M:%S")}"
            else
              text = "<a href='#{u(request.path_info)}.poll' rel='poll'>Live Poll</a>"
            end
            "<p class='poll'>#{text}</p>"
          end
        end
      end
    end

    Resque::Server.tabs << 'BRGS'
  end
end

Resque.extend BRGSResque
Resque::Server.class_eval do
  include BRGSResque::Server
end
