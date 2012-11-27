class ZabbixApi
  class HostGroups < Basic

    def initialize(client)
      @client = client
    end

    def api_method_name
      "hostgroup"
    end

    def api_ids_keys
      "groupids"
    end

    def api_id_key_sym
      :groupid
    end

    def api_id_key
      "groupid"
    end

    # Return all hostgroups
    # 
    # * *Returns* :
    #   - Hash with {"Hostgroup1" => "id1", "Hostgroup2" => "id2"}
    def all
      result = {}
      @client.api_request(:method => "hostgroup.get", :params => {:output => "extend"}).each do |hostgrp|
        result[hostgrp['name']] = hostgrp['groupid']
      end
      result
    end

  end
end
