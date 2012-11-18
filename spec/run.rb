require 'zabbixapi'

# settings
@api_url = 'http://localhost/zabbix/api_jsonrpc.php'
#@api_url = 'http://localhost/api_jsonrpc.php'
@api_login = 'Admin'
@api_password = 'zabbix'

zbx = ZabbixApi.connect(
  :url => @api_url,
  :user => @api_login,
  :password => @api_password,
  :debug => false
)

hostgroup = "hostgroup"
template  = "template"
application = "application"
item = "item"
host = "hostname"
trigger = "trigger"
user = "user"
user2 = "user2"

describe ZabbixApi, "test_api" do

  it "SERVER: Get version api" do
    zbx.server.version.should be_kind_of(String)
  end

  it "HOSTGROUP: Create" do
    zbx.hostgroup.create(:name => hostgroup).should be_kind_of(Integer)
  end

  it "HOSTGROUP: Find" do
    zbx.hostgroup.get_id(:name => [hostgroup]).should be_kind_of(Integer)
  end

  it "HOSTGROUP: Find unknown" do
    zbx.hostgroup.get_id(:name => ["#{hostgroup}______"]).should be_kind_of(NilClass)
  end

  it "TEMPLATE: Create" do
    zbx.template.create(
      :host => template,
      :groups => [:groupid => zbx.hostgroup.get_id(:name => [hostgroup])]
    ).should be_kind_of(Integer)
  end

  it "TEMPLATE: Check full data" do
    zbx.template.get_full_data(:host => template)[0]['host'].should be_kind_of(String)
  end

  it "TEMPLATE: Find" do
    zbx.template.get_id(:host => template).should be_kind_of(Integer)
  end

  it "TEMPLATE: Find unknown" do
    zbx.template.get_id(:host => "#{template}_____").should be_kind_of(NilClass)
  end

  it "APPLICATION: Create" do
    zbx.application.create(
      :name => application,
      :hostid => zbx.template.get_id(:host => template)
    )
  end

  it "APPLICATION: Full info check" do
    zbx.application.get_full_data(:name => application)[0]['applicationid'].should be_kind_of(String)
  end

  it "APPLICATION: Find" do
    zbx.application.get_id(:name => application).should be_kind_of(Integer)
  end

  it "APPLICATION: Find unknown" do
    zbx.application.get_id(:name => "#{application}___").should be_kind_of(NilClass)
  end

  it "ITEM: Create" do
    zbx.item.create(
      :description => item,
      :key_ => "proc.num[aaa]",
      :hostid => zbx.template.get_id(:host => template),
      :applications => [zbx.application.get_id(:name => application)]
    )
  end

  it "ITEM: Full info check" do
    zbx.item.get_full_data(:description => item)[0]['itemid'].should be_kind_of(String)
  end

  it "ITEM: Find" do
    zbx.item.get_id(:description => item).should be_kind_of(Integer)
  end

  it "ITEM: Update" do
    zbx.item.update(
      :itemid => zbx.item.get_id(:description => item),
      :status => 0
    ).should be_kind_of(Integer)
  end

  it "ITEM: Get unknown" do
    zbx.item.get_id(:description => "#{item}_____")
  end

  it "HOST: Create" do
    zbx.host.create(
      :host => host,
      :ip => "10.20.48.88",
      :groups => [:groupid => zbx.hostgroup.get_id(:name => [hostgroup])]
    ).should be_kind_of(Integer)
  end

  it "HOST: Find unknown" do
    zbx.host.get_id(:host => "#{host}___").should be_kind_of(NilClass)
  end

  it "HOST: Find" do
    zbx.host.get_id(:host => host).should be_kind_of(Integer)
  end

  it "HOST: Update" do
    zbx.host.update(
      :hostid => zbx.host.get_id(:host => host),
      :status => 0
    )
  end

  it "TRIGGER: Create" do
    zbx.trigger.create(
      :description => trigger,
      :expression => "{#{template}:proc.num[aaa].last(0)}<1",
      :comments => "Bla-bla is faulty (disaster)",
      :priority => 5,
      :status     => 0,
      :templateid => 0,
      :type => 0
    ).should be_kind_of(Integer)
  end

  it "TRIGGER: Find" do
    zbx.trigger.get_id(:description => [trigger]).should be_kind_of(Integer)
  end

  it "TRIGGER: Delete" do
    zbx.trigger.delete( zbx.trigger.get_id(:description => trigger) ).should be_kind_of(Integer)
  end

  it "HOST: Delete" do
    zbx.host.delete( zbx.host.get_id(:host => host) ).should be_kind_of(Integer)
  end

  it "ITEM: Delete" do
    zbx.item.delete(
      zbx.item.get_id(:description => item)
    ).should be_kind_of(Integer)
  end

  it "APPLICATION: Delete" do
    zbx.application.delete( zbx.application.get_id(:name => application) )
  end

  it "TEMPLATE: Delete" do
    zbx.template.delete(zbx.template.get_id(:host => template))
  end

  it "HOSTGROUP: Delete" do
    zbx.hostgroup.delete(
      zbx.hostgroup.get_id(:name => [hostgroup])
    ).should be_kind_of(Integer)
  end

  it "USER: Create" do
    zbx.user.create(
      :alias => "Test user",
      :name => user,
      :surname => "surname",
      :passwd => "passwd"
    ).should be_kind_of(Integer)
  end

  it "USER: Find" do
    zbx.user.get_full_data(:name => user)[0]['name'].should be_kind_of(String)
  end

  it "USER: Update" do
    zbx.user.update(:userid => zbx.user.get_id(:name => user), :name => user2).should be_kind_of(Integer)
  end

  it "USER: Find unknown" do
    zbx.user.get_id(:name => "#{user}_____")
  end

  it "USER: Delete" do
    zbx.user.delete(zbx.user.get_id(:name => user2)).should be_kind_of(Integer)
  end

end
