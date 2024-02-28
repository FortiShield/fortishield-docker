# Certificate creation image build

The dockerfile hosted in this directory is used to build the image used to boot FortiShield's single node and multi node stacks.

To create the image, the following command must be executed:

```
$ docker build -t fortishield/fortishield-certs-generator:0.0.1 .
```
