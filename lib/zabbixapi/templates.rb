class ZabbixApi
  class Templates < Basic

    def initialize(client)
      @client = client
    end

    def api_method_name
      "template"
    end

    def api_ids_keys
      "templateids"
    end

    def api_id_key_sym
      :templateid
    end

    def api_id_key
      "templateid"
    end

    # Return templateids linked with host 
    # 
    # * *Args*    :
    #   - +data+ -> Hash with :hostids => [hostid]
    # * *Returns* :
    #   - Array with templateids
    def get_ids_by_host(data)
      result = []
      @client.api_request(:method => "template.get", :params => data).each do |tmpl|
        result << tmpl['templateid']
      end
      result
    end 

    # Analog Zabbix api call massUpdate
    # 
    # * *Args*    :
    #   - +data+ -> Hash with :hosts_id => [hostid1, hostid2 ...], and :templates_id => [templateid1, templateid2 ...]
    # * *Returns* :
    #   - True or False
    def mass_update(data)
      result = @client.api_request(
        :method => "template.massAdd", 
        :params => {
          :hosts => data[:hosts_id].map { |t| {:hostid => t} },
          :templates => data[:templates_id].map { |t| {:templateid => t} }
        }
      )
      result.empty? ? false : true
    end

    # Analog Zabbix api call massAdd 
    # 
    # * *Args*    :
    #   - +data+ -> Hash with :hosts_id => [hostid1, hostid2 ...], and :templates_id => [templateid1, templateid2 ...]
    # * *Returns* :
    #   - True or False
    def mass_add(data)
      result = @client.api_request(
        :method => "template.massAdd", 
        :params => {
          :hosts => data[:hosts_id].map { |t| {:hostid => t} },
          :templates => data[:templates_id].map { |t| {:templateid => t} }
        }
      )
      result.empty? ? false : true
    end

    # Analog Zabbix api call massRemove
    # 
    # * *Args*    :
    #   - +data+ -> Hash with :hosts_id => [hostid1, hostid2 ...], and :templates_id => [templateid1, templateid2 ...]
    # * *Returns* :
    #   - True or False
    def mass_remove(data)
      result = @client.api_request(
        :method => "template.massRemove", 
        :params => {
          :hostids => data[:hosts_id],
          :templateids => data[:templates_id],
          :groupids => data[:group_id],
          :force => 1
        }
      )
      result.empty? ? false : true      
    end

    # Return all templates
    # 
    # * *Returns* :
    #   - Hash with {"Template_Name1" => "templateid1", "Template_Name2" => "templateid2"}
    def all
      result = {}
      case @client.api_version
        when "1.2"
          @client.api_request(:method => "template.get", :params => {:output => "extend"}).values.each do |tmpl|
            result[tmpl['host']] = tmpl['hostid']
          end          
        else
          @client.api_request(:method => "template.get", :params => {:output => "extend"}).each do |tmpl|
            result[tmpl['host']] = tmpl['hostid']
          end
      end
      result
    end

  end
end
