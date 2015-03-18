module NpiWS

  # - Class Methods -
  class << self

    def find_npi_info( criteria )
      command   = 'npi_query'
      subject   = 'subscription-process-step-1'
      data      = { 'SearchString' => criteria }
      query command, subject, data
    end

    private

    def query( command, subject, data )
      params = params_for_request command, subject, data
      process_response perform_request( :get, params )
    end

    def params_for_request( command, subject, data )
      {
        'Message' => {
          'Type'    => 'web2client',
          'Command' => command,
          'Subject' => subject,
          'Data'    => data
        }
      }
    end

    def process_response( response )
      if response_is_valid? response
        data = data_from_response( response )[ 'Message' ][ 'Data' ][ 'Info' ]
        data = nil if data.eql? 'No data found'
      end
      if data
        if data.is_a? Array
        data.map { |group| Hashie::Mash.new group }
        else
          Hashie::Mash.new data
        end
      end
    end

    def response_is_valid?( response )
      raise ArgumentError unless response.is_a? Typhoeus::Response
      valid   = false
      regexp  = /.*Content-Type:.*application\/json/
      if 200 == response.code
        valid = true if response.headers.match regexp
      end
      valid
    end

    def data_from_response( response )
      JSON.parse response.body
    end

    def perform_request( method = :get, params = {} )
      url       = endpoint
      response  = nil
      params.merge! :format => :json
      case method
      when :get
        response = Typhoeus::Request.get url, :params => params
      when :post
        response = Typhoeus::Request.post url, :params => params
      end
      log_bad_response response if 200 != response.code
      response
    end

    def endpoint
      @config_file  ||= File.join Rails.root, 'config', 'qliq_config.yml'
      @config       ||= YAML.load_file @config_file
      @endpoint     ||= @config[ :npi ][ :endpoint ]
    end

    def log_bad_response( response )
      message = <<-eos
Request performed on url #{ response.effective_url } returned error code #{ response.code }
at #{ Time.now }
Headers: #{ response.headers }
Body: #{ response.body }
      eos
      Rails.logger.warn message
    end

  end

end
