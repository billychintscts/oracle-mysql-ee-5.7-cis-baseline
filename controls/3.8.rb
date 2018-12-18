control "3.8" do
  title "Ensure Plugin Directory Has Appropriate Permissions and Ownership (Scored)"
  desc  "The plugin directory is the location of the MySQL plugins. 
  Plugins are storage engines or user defined functions (UDFs)"
  impact 0.5 #double check
  tag "severity": "medium"  #double check
  tag "cis_id": "3.8"
  tag "cis_control": ["No CIS Control", "6.1"] #don't know
  tag "cis_level": 1
  tag "audit text": "To assess this recommendation, execute the following SQL statement to discover the Value of plugin_dir:
  show variables where variable_name = 'plugin_dir';

  Then, execute the following command at a terminal prompt (using the discovered plugin_dir Value) to determine the permissions and ownership.
    ls -l <plugin_dir Value>/.. | egrep '^drwxr[-w]xr[-w]x[ \t]*[0-9][ \t]*mysql[ \t]*mysql.*plugin.*$'
  Lack of output implies a finding.
  NOTE: Permissions are intended to be either 775 or 755"
  tag "fix": "To remediate these settings, execute the following commands at a terminal prompt using the plugin_dir Value from the audit procedure.
    chmod 775 <plugin_dir Value> (or use 755) 
    chown mysql:mysql <plugin_dir Value>"
  tag "Default Value": ""
  query = %(select @@plugin_dir;)

  sql_session = mysql_session(attribute('user'),attribute('password'),attribute('host'),attribute('port'))
           
  plugin_dir = sql_session.query(query).stdout.strip.split

  describe directory("#{plugin_dir}") do
    it { should exist }
    its('owner') { should eq 'mysql' }
    its('group') { should eq 'mysql' }
    its('mode') { should be <= 0775 }
   end
  
end
