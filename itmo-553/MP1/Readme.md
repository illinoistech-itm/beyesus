# ITMO 453/553 MP1

This document describes the requirements for MP1

## Objectives and Outcomes

* Demonstrate the ability to deploy a multi-node virtualized infrastructure
* Demonstrate the ability to configure services through automation
* Demonstrate the ability collect and route events
* Demonstrate the ability to graph routed events

### Project Outline

This project will require you to build a variable number of virtual machines depending on Graduate or Undergraduate status.

Graduates will need to create 8 virtual machines: riemanna, riemannb, riemannmc, graphitea, graphiteb, graphitemc, host1, and host2

Undergraduates will need to create 5 virtual machines: riemanna, riemannmc, graphitea, graphitemc, host1

Your virtual machines need to be built using a packer build script and using a provisioner script that will deploy and configure all requirements so that you are able to access the Grafana graphs and see results.  

#### Riemanna Requirements

* Using Ubuntu 20.04, install Riemann and all dependencies.  
* Install Collectd and the default plugins provided in week-12 sample code folder for Riemann
* Configure the write_riemann.conf collectd plugin to send metrics to Riemanna
  * Change the nodename in the write_riemann.conf to riemanna
* Configure Riemann to send events down stream to Riemannmc
* Configure the Graphite.clj plugin to send **tagged** collectd metrics to graphitea
* Configure the Firewall (firewalld to open only the needed ports, 22, 5555,5556, and 5557)

#### Riemannb Requirements

* Using RockyLinux, install Riemann and all dependencies.  
* Install Collectd and the default plugins provided in week-12 sample code folder for Riemann
* Configure the write_riemann.conf collectd plugin to send metrics to Riemannb
  * Change the nodename in the write_riemann.conf to riemannb
* Configure Riemann to send events down stream to Riemannmc
* Configure the Graphite.clj plugin to send **tagged** collectd metrics to graphiteb
* Configure the Firewall (firewalld to open only the needed ports, 22, 5555,5556, and 5557)

#### Riemannmc Requirements

* Using Ubuntu 20.04, install Riemann and all dependencies.  
* Install Collectd and the default plugins provided in week-12 sample code folder for Riemann
* Configure the write_riemann.conf collectd plugin to send metrics to Riemannmc
  * Change the nodename in the write_riemann.conf to riemannmc
* Configure Riemann to send events down stream to Riemannmc
* Configure the Graphite.clj plugin to send **tagged** collectd metrics to graphitemc
* Configure the Firewall (firewalld to open only the needed ports, 22, 5555,5556, and 5557)
* Configure the Email.clj plugin to send an email if either riemanna or riemmanb service stops sending metrics (you can test this by stopping the Riemann service on Riemanna or Riemannb -- generating a fault).
<img width="468" alt="image" src="https://user-images.githubusercontent.com/7771250/144108566-5d492fac-db8d-4377-b4d4-3934563c59df.png">


#### Graphitea Requirements

* Using Ubuntu 20.04, install the required graphite-carbon, whisper, graphite-api, gunicorn, and grafana 7.3.6
  * https://dl.grafana.com/oss/release/grafana_7.3.6_amd64.deb
* Install Collectd and the default plugins in the week-12 sample code folder for Graphite (includes the carbon process monitor)
* Configure the write_riemann.conf collectd plugin to send metrics to Riemanna
  * Change the nodename in the write_riemann.conf to graphitea
* Configure carbon.conf Relay Line Receiver and Pickle interface to listen on the systems public IP address
* Overwrite the default files using the graphite configuration files provided in week-09 folder
* Stop the default carbon-cache and carbon-relay@1 services and overwrite them with the default services files provided in the week-09/services directory
* Enable all services on boot

#### Graphiteb Requirements

* Using Ubuntu 20.04, install the required graphite-carbon, whisper, graphite-api, gunicorn, and grafana 7.3.6
  * https://dl.grafana.com/oss/release/grafana_7.3.6_amd64.deb
* Install Collectd and the default plugins in the week-12 sample code folder for Graphite (includes the carbon process monitor)
* Configure the write_riemann.conf collectd plugin to send metrics to Riemannb
  * Change the nodename in the write_riemann.conf to graphiteb
* Configure carbon.conf Relay Line Receiver and Pickle interface to listen on the systems public IP address
* Overwrite the default files using the graphite configuration files provided in week-09 folder
* Stop the default carbon-cache and carbon-relay@1 services and overwrite them with the default services files provided in the week-09/services directory
* Enable all services on boot

#### Graphitemc Requirements

* Using Ubuntu 20.04, install the required graphite-carbon, whisper, graphite-api, gunicorn, and grafana 7.3.6
  * https://dl.grafana.com/oss/release/grafana_7.3.6_amd64.deb
* Install Collectd and the default plugins in the week-12 sample code folder for Graphite (includes the carbon process monitor)
* Configure the write_riemann.conf collectd plugin to send metrics to Riemannmc
  * Change the nodename in the write_riemann.conf to graphitemc
* Configure carbon.conf Relay Line Receiver and Pickle interface to listen on the systems public IP address
* Overwrite the default files using the graphite configuration files provided in week-09 folder
* Stop the default carbon-cache and carbon-relay@1 services and overwrite them with the default services files provided in the week-09/services directory
* Enable all services on boot

#### Host1

* Using RockyLinux, install Collectd and the Collectd plugins from week-12 (from the riemann folder in the sample code)
* Configure the write_riemann.conf collectd plugin to send metrics to Riemanna
* Note you will need to install the `epel-release` plugin and then on a separate line the `collectd-write_riemann` package via `yum`
* Change the nodename in the write_riemann.conf to host1
* **No** need to install Riemann
* You can use the IP 192.168.33.10

#### Host2

* Using RockyLinux, install Collectd and the Collectd plugins from week-12 (from the riemann folder in the sample code)
* Configure the write_riemann.conf collectd plugin to send metrics to Riemannb
* Note you will need to install the `epel-release` plugin and then on a separate line the `collectd-write_riemann` package via `yum`
* Change the nodename in the write_riemann.conf to host2
* **No** need to install Riemann
* You can use the IP 192.168.33.11

### Graphs for Grafana

* On all Graphite systems the datasource and Dashboards/Panels can be manually configured, configure a datasource to connect to the corresponding graphite-api endpoint.
* Configure 3 Dashboards, one for each Production region
* In each dashboard create the following panels:
  * Reimann streams latency
  <img width="1436" alt="image" src="https://user-images.githubusercontent.com/7771250/144107289-6fa76ed6-e869-4b4f-bbaf-1043d208c9cf.png">

  * Carbon Process
  <img width="1439" alt="image" src="https://user-images.githubusercontent.com/7771250/144107202-a70bd331-8677-4ed6-8c35-9bff399083c7.png">

  * Collectd process 
  <img width="1103" alt="image" src="https://user-images.githubusercontent.com/7771250/144106950-9281ee22-d9c4-487f-8295-99e69ef12d01.png">
 
  * Group by CPU (user and system) for all hosts
  <img width="1434" alt="image" src="https://user-images.githubusercontent.com/7771250/144107377-ca8b080d-8142-4b89-9c7a-71c80469c1c1.png">

  * Alias by Memory (used) all hosts
  <img width="1435" alt="image" src="https://user-images.githubusercontent.com/7771250/144107447-f0618ce5-19f6-4b07-9289-361717138719.png">

  * Alias by Disk used (df root_percent bytes)
  <img width="1439" alt="image" src="https://user-images.githubusercontent.com/7771250/144108260-5791ac5d-4e59-4883-bd9d-aa29d88431b8.png">

* Once all charts are created use the **export** feature in Grafana to export your graphs into json format -- only 1 system is needed graphitea.  Include these json files in your mp1 folder.

## Deliverable

Create a folder named mp1 into your GitHub class repo.  Copy this mp1.md template into the folder.  Added screenshots of all the bullet point graphs in the previous section and add those screenshots to your mp1.md document.   Submit the URL to your MP1 document to Blackboard.
