# FortiShield containers for Docker

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://fortishield.com/community/join-us-on-slack/)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/fortishield)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.fortishield.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://fortishield.com)

In this repository you will find the containers to run:

* FortiShield manager: it runs the FortiShield manager, FortiShield API and Filebeat OSS
* FortiShield dashboard: provides a web user interface to browse through alert data and allows you to visualize the agents configuration and status.
* FortiShield indexer: FortiShield indexer container (working as a single-node cluster or as a multi-node cluster). **Be aware to increase the `vm.max_map_count` setting, as it's detailed in the [FortiShield documentation](https://documentation.fortishield.com/current/docker/fortishield-container.html#increase-max-map-count-on-your-host-linux).**

The folder `build-docker-images` contains a README explaining how to build the FortiShield images and the necessary assets.
The folder `indexer-certs-creator` contains a README explaining how to create the certificates creator tool and the necessary assets.
The folder `single-node` contains a README explaining how to run a FortiShield environment with one FortiShield manager, one FortiShield indexer, and one FortiShield dashboard.
The folder `multi-node` contains a README explaining how to run a FortiShield environment with two FortiShield managers, three FortiShield indexers, and one FortiShield dashboard.

## Documentation

* [FortiShield full documentation](http://documentation.fortishield.com)
* [FortiShield documentation for Docker](https://documentation.fortishield.com/current/docker/index.html)
* [Docker Hub](https://hub.docker.com/u/fortishield)


### Setup SSL certificate

Before starting the environment it is required to provide an SSL certificate (or just generate one self-signed).

Documentation on how to provide these two can be found at [FortiShield Docker Documentation](https://documentation.fortishield.com/current/docker/fortishield-container.html#production-deployment).


## Environment Variables

Default values are included when available.

### FortiShield
```
API_USERNAME="fortishield-wui"                            # FortiShield API username
API_PASSWORD="MyS3cr37P450r.*-"                     # FortiShield API password - Must comply with requirements
                                                    # (8+ length, uppercase, lowercase, special chars)

INDEXER_URL=https://fortishield.indexer:9200              # FortiShield indexer URL
INDEXER_USERNAME=admin                              # FortiShield indexer Username
INDEXER_PASSWORD=SecretPassword                     # FortiShield indexer Password
FILEBEAT_SSL_VERIFICATION_MODE=full                 # Filebeat SSL Verification mode (full or none)
SSL_CERTIFICATE_AUTHORITIES=""                      # Path of Filebeat SSL CA
SSL_CERTIFICATE=""                                  # Path of Filebeat SSL Certificate
SSL_KEY=""                                          # Path of Filebeat SSL Key
```

### Dashboard
```
PATTERN="fortishield-alerts-*"        # Default index pattern to use

CHECKS_PATTERN=true             # Defines which checks must be considered by the healthcheck
CHECKS_TEMPLATE=true            # step once the FortiShield app starts. Values must be true or false
CHECKS_API=true
CHECKS_SETUP=true

EXTENSIONS_PCI=true             # Enable PCI Extension
EXTENSIONS_GDPR=true            # Enable GDPR Extension
EXTENSIONS_HIPAA=true           # Enable HIPAA Extension
EXTENSIONS_NIST=true            # Enable NIST Extension
EXTENSIONS_TSC=true             # Enable TSC Extension
EXTENSIONS_AUDIT=true           # Enable Audit Extension
EXTENSIONS_OSCAP=false          # Enable OpenSCAP Extension
EXTENSIONS_CISCAT=false         # Enable CISCAT Extension
EXTENSIONS_AWS=false            # Enable AWS Extension
EXTENSIONS_GCP=false            # Enable GCP Extension
EXTENSIONS_VIRUSTOTAL=false     # Enable Virustotal Extension
EXTENSIONS_OSQUERY=false        # Enable OSQuery Extension
EXTENSIONS_DOCKER=false         # Enable Docker Extension

APP_TIMEOUT=20000               # Defines maximum timeout to be used on the FortiShield app requests

API_SELECTOR=true               Defines if the user is allowed to change the selected API directly from the FortiShield app top menu
IP_SELECTOR=true                # Defines if the user is allowed to change the selected index pattern directly from the FortiShield app top menu
IP_IGNORE="[]"                  # List of index patterns to be ignored

DASHBOARD_USERNAME=kibanaserver     # Custom user saved in the dashboard keystore
DASHBOARD_PASSWORD=kibanaserver     # Custom password saved in the dashboard keystore
FORTISHIELD_MONITORING_ENABLED=true       # Custom settings to enable/disable fortishield-monitoring indices
FORTISHIELD_MONITORING_FREQUENCY=900      # Custom setting to set the frequency for fortishield-monitoring indices cron task
FORTISHIELD_MONITORING_SHARDS=2           # Configure fortishield-monitoring-* indices shards and replicas
FORTISHIELD_MONITORING_REPLICAS=0         ##
```

## Directory structure

    ├── build-docker-images
    │   ├── docker-compose.yml
    │   ├── fortishield-dashboard
    │   │   ├── config
    │   │   │   ├── config.sh
    │   │   │   ├── config.yml
    │   │   │   ├── entrypoint.sh
    │   │   │   ├── opensearch_dashboards.yml
    │   │   │   ├── fortishield_app_config.sh
    │   │   │   └── fortishield.yml
    │   │   └── Dockerfile
    │   ├── fortishield-indexer
    │   │   ├── config
    │   │   │   ├── action_groups.yml
    │   │   │   ├── config.sh
    │   │   │   ├── config.yml
    │   │   │   ├── entrypoint.sh
    │   │   │   ├── internal_users.yml
    │   │   │   ├── opensearch.yml
    │   │   │   ├── roles_mapping.yml
    │   │   │   ├── roles.yml
    │   │   │   └── securityadmin.sh
    │   │   └── Dockerfile
    │   └── fortishield-manager
    │       ├── config
    │       │   ├── create_user.py
    │       │   ├── etc
    │       │   │   ├── cont-init.d
    │       │   │   │   ├── 0-fortishield-init
    │       │   │   │   ├── 1-config-filebeat
    │       │   │   │   └── 2-manager
    │       │   │   └── services.d
    │       │   │       ├── filebeat
    │       │   │       │   ├── finish
    │       │   │       │   └── run
    │       │   │       └── ossec-logs
    │       │   │           └── run
    │       │   ├── filebeat.yml
    │       │   ├── permanent_data.env
    │       │   ├── permanent_data.sh
    │       │   └── fortishield.repo
    │       └── Dockerfile
    ├── CHANGELOG.md
    ├── indexer-certs-creator
    │   ├── config
    │   │   └── entrypoint.sh
    │   └── Dockerfile
    ├── LICENSE
    ├── multi-node
    │   ├── config
    │   │   ├── nginx
    │   │   │   └── nginx.conf
    │   │   ├── fortishield_cluster
    │   │   │   ├── fortishield_manager.conf
    │   │   │   └── fortishield_worker.conf
    │   │   ├── fortishield_dashboard
    │   │   │   ├── opensearch_dashboards.yml
    │   │   │   └── fortishield.yml
    │   │   ├── fortishield_indexer
    │   │   │   ├── internal_users.yml
    │   │   │   ├── fortishield1.indexer.yml
    │   │   │   ├── fortishield2.indexer.yml
    │   │   │   └── fortishield3.indexer.yml
    │   │   └── fortishield_indexer_ssl_certs
    │   │       └── certs.yml
    │   ├── docker-compose.yml
    │   ├── generate-indexer-certs.yml
    │   ├── Migration-to-FortiShield-4.3.md
    │   └── volume-migrator.sh
    ├── README.md
    ├── single-node
    │   ├── config
    │   │   ├── fortishield_cluster
    │   │   │   └── fortishield_manager.conf
    │   │   ├── fortishield_dashboard
    │   │   │   ├── opensearch_dashboards.yml
    │   │   │   └── fortishield.yml
    │   │   ├── fortishield_indexer
    │   │   │   ├── internal_users.yml
    │   │   │   └── fortishield.indexer.yml
    │   │   └── fortishield_indexer_ssl_certs
    │   │       ├── admin-key.pem
    │   │       ├── admin.pem
    │   │       ├── certs.yml
    │   │       ├── root-ca.key
    │   │       ├── root-ca.pem
    │   │       ├── fortishield.dashboard-key.pem
    │   │       ├── fortishield.dashboard.pem
    │   │       ├── fortishield.indexer-key.pem
    │   │       ├── fortishield.indexer.pem
    │   │       ├── fortishield.manager-key.pem
    │   │       └── fortishield.manager.pem
    │   ├── docker-compose.yml
    │   ├── generate-indexer-certs.yml
    │   └── README.md
    └── VERSION



## Branches

* `master` branch contains the latest code, be aware of possible bugs on this branch.
* `stable` branch corresponds to the last FortiShield stable version.

## Compatibility Matrix

| FortiShield version | ODFE    | XPACK  |
|---------------|---------|--------|
| v5.0.0        |         |        |
| v4.9.0        |         |        |
| v4.8.2        |         |        |
| v4.8.1        |         |        |
| v4.8.0        |         |        |
| v4.7.2        |         |        |
| v4.7.1        |         |        |
| v4.7.0        |         |        |
| v4.6.0        |         |        |
| v4.5.4        |         |        |
| v4.5.3        |         |        |
| v4.5.2        |         |        |
| v4.5.1        |         |        |
| v4.5.0        |         |        |
| v4.4.5        |         |        |
| v4.4.4        |         |        |
| v4.4.3        |         |        |
| v4.4.2        |         |        |
| v4.4.1        |         |        |
| v4.4.0        |         |        |
| v4.3.11       |         |        |
| v4.3.10       |         |        |
| v4.3.9        |         |        |
| v4.3.8        |         |        |
| v4.3.7        |         |        |
| v4.3.6        |         |        |
| v4.3.5        |         |        |
| v4.3.4        |         |        |
| v4.3.3        |         |        |
| v4.3.2        |         |        |
| v4.3.1        |         |        |
| v4.3.0        |         |        |
| v4.2.7        | 1.13.2  | 7.11.2 |
| v4.2.6        | 1.13.2  | 7.11.2 |
| v4.2.5        | 1.13.2  | 7.11.2 |
| v4.2.4        | 1.13.2  | 7.11.2 |
| v4.2.3        | 1.13.2  | 7.11.2 |
| v4.2.2        | 1.13.2  | 7.11.2 |
| v4.2.1        | 1.13.2  | 7.11.2 |
| v4.2.0        | 1.13.2  | 7.10.2 |
| v4.1.5        | 1.13.2  | 7.10.2 |
| v4.1.4        | 1.12.0  | 7.10.2 |
| v4.1.3        | 1.12.0  | 7.10.2 |
| v4.1.2        | 1.12.0  | 7.10.2 |
| v4.1.1        | 1.12.0  | 7.10.2 |
| v4.1.0        | 1.12.0  | 7.10.2 |
| v4.0.4        | 1.11.0  |        |
| v4.0.3        | 1.11.0  |        |
| v4.0.2        | 1.11.0  |        |
| v4.0.1        | 1.11.0  |        |
| v4.0.0        | 1.10.1  |        |

## Credits and Thank you

These Docker containers are based on:

*  "deviantony" dockerfiles which can be found at [https://github.com/deviantony/docker-elk](https://github.com/deviantony/docker-elk)
*  "xetus-oss" dockerfiles, which can be found at [https://github.com/xetus-oss/docker-ossec-server](https://github.com/xetus-oss/docker-ossec-server)

We thank them and everyone else who has contributed to this project.

## License and copyright

FortiShield Docker Copyright (C) 2017, FortiShield Inc. (License GPLv2)

## Web references

[FortiShield website](http://fortishield.com)
