DevOps sandbox / Ganglia
========================

**[Ganglia](http://ganglia.sourceforge.net) sandbox.**


Virtual machines
----------------

* **`server`**: Hosts Ganglia aggregation daemon (gmetad) and Web interface.
* **`node1-9`**: Runs Ganglia collection daemon (gmond).

Usage
-----
1. Resolve Puppet modules:

       librarian-puppet update

2. Start server:

    vagrant up server

3. Start some nodes:

    vagrant up node1

4. Access Ganglia Web interface at <http://locahost:9000/ganglia>.
