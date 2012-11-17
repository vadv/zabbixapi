class ZabbixApi
  class Server

    def initialize(options = {})
      @client = Client.new(options)
    end

    def version
      @client.api_request(:method => "apiinfo.version", :params => {})
    end

  end
end