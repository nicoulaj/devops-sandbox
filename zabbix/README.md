DevOps sandbox / Zabbix
=======================

**[Zabbix](http://www.zabbix.com) sandbox.**


Virtual machines
----------------

* **`server`**: Hosts the Zabbix server and Web interface.
* **`node1-9`**: Runs Zabbix agent.

Usage
-----
1. Resolve Puppet modules:

        librarian-puppet update 

2. Start server:

        vagrant up server

3. Start some nodes:

        vagrant up node1

4. Access Zabbex Web interface at <http://locahost:9000/zabbix>.

5. Login with `Admin`/`zabbix`.
