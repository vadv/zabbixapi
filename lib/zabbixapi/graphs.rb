class ZabbixApi
  class Graphs < Basic

    def initialize(client)
      @client = client
    end

    def api_method_name
      "graph"
    end

    def api_ids_keys
      "graphids"
    end

    def api_id_key_sym
      :graphid
    end

    def api_id_key
      "graphid"
    end

    def delete(data)
      result = @client.api_request(:method => "graph.delete", :params => [data])
      case @client.api_version
        when "1.3"
          result ? 1 : nil  #return "true" or "false" for this api version
        else
          result.empty? ? nil : result['graphids'][0].to_i
      end
    end

    def get_ids_by_host(data)
      ids = []
      result = @client.api_request(:method => "graph.get", :params => {:filter => {:host => data[:host]}, :output => "extend"})
      result.each do |graph|
        ids << graph['graphid']
      end
      ids
    end

    def get_items(data)
      @client.api_request(:method => "graphitem.get", :params => { :graphids => [data], :output => "extend" } )
    end

    def create_or_update(data)
      graphid = get_id(:name => data[:name], :templateid => data[:templateid])
      graphid ? _update(data.merge(:graphid => graphid)) : create(data)
    end

    def _update(data)
      data.delete(:name)
      update(data)
    end

    def update(data)
      case @client.api_version
        when "1.2"
          @client.api_request(:method => "graph.update", :params => data) 
        else
          result = @client.api_request(:method => "graph.update", :params => data)
          result.empty? ? nil : result['graphids'][0].to_i
      end
    end

  end
end
