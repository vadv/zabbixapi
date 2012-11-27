class ZabbixApi
  class Basic

    def create(data)
      result = @client.api_request(:method => "#{api_method_name}.create", :params => [data])
      result.empty? ? nil : result[api_ids_keys][0].to_i
    end

    def add(data)
      create(data)
    end

    def delete(data)
      result = @client.api_request(:method => "#{api_method_name}.delete", :params => [api_id_key_sym => data])
      result.empty? ? nil : result[api_ids_keys][0].to_i
    end

    def destroy(data)
      delete(data)
    end

    def get_full_data(data)
      @client.api_request(:method => "#{api_method_name}.get", :params => {:search => {:name => data}, :output => "extend"})
    end

    def get_id(data)
      result = get_full_data(data)
      id = nil
      result.each { |tmpl| id = tmpl[api_id_key].to_i if tmpl['name'] == data[:name] }
      id
    end

    def get_or_create(data)
      unless id = get_id(data)
        id = update(data)
      end
      return id
    end

    def api_method_name
      raise "Can't call here"
    end

    def api_ids_keys
      raise "Can't call here"
    end

    def api_id_key_sym
      raise "Can't call here"
    end

    def api_id_key
      raise "Can't call here"
    end

    def api_char_name
      raise "Can't call here"
    end

  end
end
