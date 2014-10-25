
### installing linux driver manager ###

package "unixodbc" do
	action :install
end

### unzipping ###

directory node['freetds']['path'] do
	recursive true 
	action :create
end

### unzipping freetds ###

cookbook_file "freetds-stable.tgz" do
	path "#{node['freetds']['path']}/freetds-stable.tgz"
	action :create
end

execute "unzipping freetds-stable.tgz" do
	cwd node['freetds']['path']
	command "tar zxvf freetds-stable.tgz"
end

### building freetds ###

execute "building freetds" do
	cwd "#{node['freetds']['path']}/freetds-0.91"
	command "./configure --prefix=#{node['freetds']['path']} --with-tdsver=7.0 && make && make install"
end

### installing freetds with driver manager ###

template "#{node['freetds']['path']}/driver_install.txt" do
	source "driver_install.txt.erb"
	action :create
end

execute "installing driver with manager" do
	cwd node['freetds']['path']
	command "odbcinst -i -d -f driver_install.txt"
end