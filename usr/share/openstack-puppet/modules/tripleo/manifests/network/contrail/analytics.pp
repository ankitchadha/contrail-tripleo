#
# Copyright (C) 2015 Juniper Networks
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::network::contrail::analytics
#
# Configure Contrail Analytics services
#
# == Parameters:
#
# [*host_ip*]
#  (required) host IP address of Analytics
#  String (IPv4) value.
#
# [*admin_password*]
#  (optional) admin password
#  String value.
#  Defaults to hiera('contrail::admin_password')
#
# [*admin_tenant_name*]
#  (optional) admin tenant name.
#  String value.
#  Defaults to hiera('contrail::admin_tenant_name')
#
# [*admin_token*]
#  (optional) admin token
#  String value.
#  Defaults to hiera('contrail::admin_token')
#
# [*admin_user*]
#  (optional) admin user name.
#  String value.
#  Defaults to hiera('contrail::admin_user')
#
# [*auth_host*]
#  (optional) keystone server ip address
#  String (IPv4) value.
#  Defaults to hiera('contrail::auth_host')
#
# [*auth_port*]
#  (optional) keystone port.
#  Integer value.
#  Defaults to hiera('contrail::auth_port')
#
# [*auth_protocol*]
#  (optional) authentication protocol.
#  String value.
#  Defaults to hiera('contrail::auth_protocol')
#
# [*cassandra_server_list*]
#  (optional) List IPs+port of Cassandra servers
#  Array of strings value.
#  Defaults to hiera('contrail::cassandra_server_list')
#
# [*collector_http_server_port*]
#  (optional) Collector http port
#  Integer value.
#  Defaults to 8089
#
# [*collector_sandesh_port*]
#  (optional) Collector sandesh port
#  Integer value.
#  Defaults to 8086
#
# [*disc_server_ip*]
#  (optional) IPv4 address of discovery server.
#  String (IPv4) value.
#  Defaults to hiera('contrail::disc_server_ip')
#
# [*disc_server_port*]
#  (optional) port Discovery server listens on.
#  Integer value.
#  Defaults to hiera('contrail::disc_server_port')
#
# [*http_server_port*]
#  (optional) Analytics http port
#  Integer value.
#  Defaults to 8090
#
# [*insecure*]
#  (optional) insecure mode.
#  Boolean value.
#  Defaults to falsehiera('contrail::insecure')
#
# [*kafka_broker_list*]
#  (optional) List IPs+port of kafka servers
#  Array of strings value.
#  Defaults to hiera('contrail::kafka_broker_list')
#
# [*memcached_servers*]
#  (optional) IPv4 address of memcached servers
#  String (IPv4) value + port
#  Defaults to hiera('contrail::memcached_server')
#
# [*redis_server*]
#  (optional) IPv4 address of redis server.
#  String (IPv4) value.
#  Defaults to '127.0.0.1'.
#
# [*redis_server_port*]
#  (optional) port Redis server listens on.
#  Integer value.
#  Defaults to 6379
#
# [*rest_api_ip*]
#  (optional) IP address Analytics rest interface listens on
#  String (IPv4) value.
#  Defaults to '0.0.0.0'
#
# [*rest_api_port*]
#  (optional) Analytics rest port
#  Integer value.
#  Defaults to 8081
#
# [*zk_server_ip*]
#  (optional) List IPs+port of Zookeeper servers
#  Array of strings value.
#  Defaults to hiera('contrail::zk_server_ip')
#
class tripleo::network::contrail::analytics(
  $step = hiera('step'),
  $host_ip = $::ipaddress,
  $admin_password = hiera('contrail::admin_password'),
  $api_server = hiera('controller_virtual_ip'),
  $admin_tenant_name = hiera('contrail::admin_tenant_name'),
  $admin_token = hiera('contrail::admin_token'),
  $admin_user = hiera('contrail::admin_user'),
  $auth_host = hiera('contrail::auth_host'),
  $auth_port = hiera('contrail::auth_port'),
  $auth_protocol = hiera('contrail::auth_protocol'),
  $cassandra_server_list = hiera('contrail_database_node_ips'),
  $collector_http_server_port = 8089,
  $collector_sandesh_port = 8086,
  $disc_server_ip = hiera('controller_virtual_ip'),
  $disc_server_port = hiera('contrail::disc_server_port'),
  $http_server_port = 8090,
  $insecure = hiera('contrail::insecure'),
  $kafka_broker_list = hiera('contrail_database_node_ips'),
  $memcached_servers = hiera('contrail::memcached_server'),
  $rabbit_server = hiera('rabbitmq_node_ips'),
  $rabbit_user = hiera('contrail::rabbit_user'),
  $rabbit_password = hiera('contrail::rabbit_password'),
  $rabbit_port = hiera('contrail::rabbit_port'),
  $redis_server = '127.0.0.1',
  $redis_server_port = 6379,
  $rest_api_ip = '0.0.0.0',
  $rest_api_port = 8081,
  $zk_server_ip = hiera('contrail_database_node_ips'),
)
{
  $cassandra_server_list_9042 = join([join($zk_server_ip, ':9042 '),":9042"],'')
  $zk_server_ip_2181 = join([join($zk_server_ip, ':2181 '),":2181"],'')
  $zk_server_ip_2181_comma = join([join($zk_server_ip, ':2181,'),":2181"],'')
  $kafka_broker_list_9092 = join([join($kafka_broker_list, ':9092 '),":9092"],'')
  $rabbit_server_list_5672 = join([join($rabbit_server, ':5672,'),":5672"],'')
  $redis_config = "bind ${host_ip} 127.0.0.1"
  class {'::contrail::keystone':
    keystone_config => {
      'KEYSTONE' => {
        'admin_password'    => $admin_password,
        'admin_tenant_name' => $admin_tenant_name,
        'admin_user'        => $admin_user,
        'auth_host'         => $auth_host,
        'auth_port'         => $auth_port,
        'auth_protocol'     => $auth_protocol,
        'insecure'          => $insecure,
        'memcache_servers'  => $memcached_servers,
      },
    },
  } ->
  class {'::contrail::analytics':
    alarm_gen_config       => {
      'DEFAULTS'  => {
        'host_ip'              => $host_ip,
        'kafka_broker_list'    => $kafka_broker_list_9092,
        'rabbitmq_server_list' => $rabbit_server_list_5672,
        'rabbitmq_user'        => $rabbit_user,
        'rabbitmq_password'    => $rabbit_password,
        'zk_list'         => $zk_server_ip_2181,
      },
      'DISCOVERY' => {
        'disc_server_ip'   => $disc_server_ip,
        'disc_server_port' => $disc_server_port,
      },
    },
    analytics_nodemgr_config  => {
      'DISCOVERY' => {
        'server'   => $disc_server_ip,
        'port'     => $disc_server_port,
      },
    },
    analytics_api_config  => {
      'DEFAULTS'  => {
        'cassandra_server_list' => $cassandra_server_list_9042,
        'host_ip'               => $host_ip,
        'http_server_port'      => $http_server_port,
        'rest_api_ip'           => $rest_api_ip,
        'rest_api_port'         => $rest_api_port,
      },
      'DISCOVERY' => {
        'disc_server_ip'   => $disc_server_ip,
        'disc_server_port' => $disc_server_port,
      },
      'REDIS'     => {
        'redis_server_port' => $redis_server_port,
        'redis_query_port'  => $redis_server_port,
        'server'            => $redis_server,
      },
      'KEYSTONE'     => {
        'admin_password'    => $admin_password,
        'admin_tenant_name' => $admin_tenant_name,
        'admin_user'        => $admin_user,
        'auth_host'         => $auth_host,
        'auth_port'         => $auth_port,
        'auth_protocol'     => $auth_protocol,
        'insecure'          => $insecure,
      },
    },
    collector_config      => {
      'DEFAULT'  => {
        'cassandra_server_list' => $cassandra_server_list_9042,
        'hostip'                => $host_ip,
        'http_server_port'      => $collector_http_server_port,
        'kafka_broker_list'     => $kafka_broker_list_9092,
        'zookeeper_server_list' => $zk_server_ip_2181_comma,
      },
      'COLLECTOR' => {
        'port' => $collector_sandesh_port,
      },
      'DISCOVERY' => {
        'port'   => $disc_server_port,
        'server' => $disc_server_ip,
      },
      'REDIS'     => {
        'port'   => $redis_server_port,
        'server' => $redis_server,
      },
    },
    query_engine_config   => {
      'DEFAULT'  => {
        'cassandra_server_list' => $cassandra_server_list_9042,
        'hostip'                => $host_ip,
      },
      'DISCOVERY' => {
        'port'   => $disc_server_port,
        'server' => $disc_server_ip,
      },
      'REDIS'     => {
        'port'   => $redis_server_port,
        'server' => $redis_server,
      },
    },
    snmp_collector_config => {
      'DEFAULTS'  => {
        'zookeeper' => $zk_server_ip_2181_comma,
      },
      'DISCOVERY' => {
        'disc_server_ip'   => $disc_server_ip,
        'disc_server_port' => $disc_server_port,
      },
    },
    redis_config          => $redis_config,
    topology_config       => {
      'DEFAULTS'  => {
        'zookeeper' => $zk_server_ip_2181_comma,
      },
      'DISCOVERY' => {
        'disc_server_ip'   => $disc_server_ip,
        'disc_server_port' => $disc_server_port,
      },
    },
  }
  if $step >= 5 {
    class {'::contrail::analytics::provision_analytics':
      api_address => $api_server,
      keystone_admin_user => $admin_user,
      keystone_admin_password => $admin_password,
      keystone_admin_tenant_name => $admin_tenant_name,
      openstack_vip => $auth_host,
    }
  }
}
