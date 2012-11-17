class ZabbixApi

  attr :client
  attr :server
  attr :user
  attr :item
  attr :application
  attr :template
  attr :hostgroup

  def self.connect(options = {})
    new(options)
  end

  def self.current
    @current ||= ZabbixApi.new
  end

  def initialize(options = {})
    @client = Client.new(options)
    @server = Server.new(options)
    @user   = User.new(options)
    @item   = Item.new(options)
    @application = Application.new(options)
    @template    = Template.new(options)
    @hostgroup   = HostGroup.new(options)
  end

end

require "zabbixapi/version"
require "zabbixapi/client"
require "zabbixapi/server"
require "zabbixapi/application"
require "zabbixapi/template"
require "zabbixapi/hostgroup"
require "zabbixapi/user"
require "zabbixapi/item"