require 'zabbixapi'

# settings
api_url = 'http://localhost/zabbix/api_jsonrpc.php'
api_url = 'http://localhost/api_jsonrpc.php'
api_login = 'Admin'
api_password = 'zabbix'

zbx = ZabbixApi.connect(:url => api_url, :user => api_login, :password => api_password, :debug => true)

describe ZabbixApi, "test_api" do

  it "Server version" do
    zbx.server.version.should be_kind_of(String)
  end

  it "Create hostgroup" do
    zbx.hostgroup.create(:name => "somehostgroup").should be_kind_of(Integer)
  end

  it "Get hostgroup" do
    zbx.hostgroup.get_id(:name => ["somehostgroup"]).should be_kind_of(Integer)
  end

  it "Get undefined hostgroup" do
    zbx.hostgroup.get_id(:name => ["somehostgroup______"]).should be_kind_of(NilClass)
  end

  it "Create template" do
    zbx.template.create(
      :host => "SomeTestApp", 
      :groups => [:groupid => zbx.hostgroup.get_id(:name => ["somehostgroup"])]
    ).should be_kind_of(Integer)
  end

  it "Get template full info" do
    zbx.template.get_full_data(:host => "SomeTestApp")[0]['host'].should be_kind_of(String)
  end

  it "Get template id" do
    zbx.template.get_id(:host => "SomeTestApp").should be_kind_of(Integer)
  end

  it "Get undefined template" do
    zbx.template.get_id(:host => "SomeTestApp_____").should be_kind_of(NilClass)
  end

  it "Create application" do
    zbx.application.create(
      :name => "TestApp", 
      :hostid => zbx.template.get_id(:host => "SomeTestApp") 
    )
  end

  it "Get application full info" do
    zbx.application.get_full_data(:name => "TestApp")[0]['applicationid'].should be_kind_of(String)
  end

  it "Get application id" do
    zbx.application.get_id(:name => "TestApp").should be_kind_of(Integer)
  end

  it "Get unknown application" do
    zbx.application.get_id(:name => "TestApp___").should be_kind_of(NilClass)
  end

  it "Create item" do
    zbx.item.create(
      :description => "SomeItem", 
      :key_ => "vfs.fs.size[/var,free]", 
      :type => 0,
#      :templateid => zbx.template.get_id(:host => "SomeTestApp"), 
      :hostid => zbx.hostgroup.get_id(:name => ["somehostgroup"]).to_s, 
      :applications => [zbx.application.get_full_data(:name => "TestApp")[0]['applicationid']],
      :history => 7,
      :trends => 30,
      :delay => 60,
      :value_type => 0
    )
  end

  it "Get item full info" do
    zbx.item.get_full_data(:description => "SomeItem")[0]['itemid'].should be_kind_of(String)
  end

  it "Get item id" do
    zbx.item.get_id(:description => "SomeItem").should be_kind_of(Integer)
  end

  it "Update item" do
    zbx.item.get_id(
      :itemid => zbx.item.get_id(:description => "SomeItem"),
      :status => 0
    ).should be_kind_of(Integer)
  end

  it "Get unknown item" do
    zbx.item.get_id(:description => "SomeItem_____")
  end  

  it "Delete item" do 
    zbx.item.delete(
      :itemids => [zbx.item.get_id(:description => "SomeItem")]
    ).should be_kind_of(Integer)
  end

  it "Delete application" do 
    zbx.application.delete( zbx.application.get_id(:name => "TestApp") )
  end

  it "Destroy temlate" do
    zbx.template.delete(:templateid => zbx.template.get_id(:host => "SomeTestApp"))
  end

  it "Destroy hostgroup" do
    zbx.hostgroup.delete(
      :groupid => zbx.hostgroup.get_id(:name => ["somehostgroup"])
    ).should be_kind_of(Integer)
  end

  it "Create user" do
    zbx.user.create(
      :alias => "Test user", 
      :name => "name", 
      :surname => "surname", 
      :passwd => "passwd"
    ).should be_kind_of(Integer)
  end

  it "Find user" do
    zbx.user.get_full_data(:name => "name")[0]['name'].should be_kind_of(String)
  end

  it "Update user" do
    zbx.user.update(:userid => zbx.user.get_id(:name => "name"), :name => "name2").should be_kind_of(Integer)
  end

  it "Find unknown user" do
    zbx.user.get_id(:name => "name111")
  end

  it "Delete user" do
    zbx.user.delete_by_id(zbx.user.get_id(:name => "name2")).should be_kind_of(Integer)
  end

end