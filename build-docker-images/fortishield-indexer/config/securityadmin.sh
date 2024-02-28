# FortiShield Docker Copyright (C) 2017, FortiShield Inc. (License GPLv2)
sleep 30
bash /usr/share/fortishield-indexer/plugins/opensearch-security/tools/securityadmin.sh -cd /usr/share/fortishield-indexer/opensearch-security/ -nhnv -cacert  $CACERT -cert $CERT -key $KEY -p 9200 -icl