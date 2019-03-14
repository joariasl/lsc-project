# lsc-project

## Running passing LSC Configuration

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
<PARAMS>
```

### Examples

#### Validate

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -v
```

#### Run Dry-run

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -c all -s all -n
```

#### Run all synchronization tasks

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -c all -s all
```

#### Run as daemon

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -a all
```

## Run bash as entrypoint

```sh
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
--entrypoint /bin/bash \
jariasl/lsc-project
```

## LSC Configuration example

ActiveDirectory to OpenLDAP

```xml
<?xml version="1.0" encoding="UTF-8"?>
<lsc xmlns="http://lsc-project.org/XSD/lsc-core-2.1.xsd" revision="0">

    <connections>
        <ldapConnection>
            <name>ldap-source</name>
            <url>ldap://example.ad:389/dc=example,dc=com</url>
            <username>dc=my-domain,dc=com</username>
            <password>secret</password>
            <authentication>SIMPLE</authentication>
            <version>VERSION_3</version>
            <pageSize>1000</pageSize>
            <tlsActivated>false</tlsActivated>
        </ldapConnection>
        <ldapConnection>
            <name>ldap-target</name>
            <url>ldap://my-domain.com:389/dc=my-domain,dc=com</url>
            <username>cn=Administrator,dc=my-domain,dc=com</username>
            <password>secret2</password>
            <authentication>SIMPLE</authentication>
            <version>VERSION_3</version>
            <tlsActivated>false</tlsActivated>
        </ldapConnection>
    </connections>

    <tasks>

        <task>
            <name>ou</name>
            <bean>org.lsc.beans.SimpleBean</bean>
            <ldapSourceService>
                <name>group-source-service</name>
                <connection reference="ldap-source" />
                <baseDn>dc=example,dc=com</baseDn>
                <pivotAttributes>
                    <string>ou</string>
                </pivotAttributes>
                <fetchedAttributes>
                    <string>ou</string>
                    <string>description</string>
                </fetchedAttributes>
                <getAllFilter><![CDATA[(objectClass=organizationalUnit)]]></getAllFilter>
                <getOneFilter><![CDATA[(&(objectClass=organizationalUnit)(ou={ou}))]]></getOneFilter>
                <cleanFilter><![CDATA[(&(objectClass=organizationalUnit)(ou={ou}))]]></cleanFilter>
            </ldapSourceService>
            <ldapDestinationService>
                <name>group-dst-service</name>
                <connection reference="ldap-target" />
                <baseDn>dc=my-domain,dc=com</baseDn>
                <pivotAttributes>
                    <string>ou</string>
                </pivotAttributes>
                <fetchedAttributes>
                    <string>ou</string>
                    <string>description</string>
                    <string>objectClass</string>
                </fetchedAttributes>
                <getAllFilter><![CDATA[(objectClass=organizationalUnit)]]></getAllFilter>
                <getOneFilter><![CDATA[(&(objectClass=organizationalUnit)(ou={ou}))]]></getOneFilter>
            </ldapDestinationService>
            <propertiesBasedSyncOptions>
                <mainIdentifier>srcBean.getMainIdentifier()</mainIdentifier>
                <defaultDelimiter>;</defaultDelimiter>
                <defaultPolicy>FORCE</defaultPolicy>
                <conditions>
                    <create>true</create>
                    <update>true</update>
                    <delete>false</delete>
                    <changeId>true</changeId>
                </conditions>
                <dataset>
                    <name>objectclass</name>
                    <policy>KEEP</policy>
                    <createValues>
                        <string>"organizationalUnit"</string>
                        <string>"top"</string>
                    </createValues>
                </dataset>
            </propertiesBasedSyncOptions>
        </task>

        <task>
            <name>user</name>
            <bean>org.lsc.beans.SimpleBean</bean>
            <ldapSourceService>
                <name>ad-src-service</name>
                <connection reference="ldap-source" />
                <baseDn>dc=example,dc=com</baseDn>
                <pivotAttributes>
                    <string>sAMAccountName</string>
                </pivotAttributes>
                <fetchedAttributes>
                    <string>dn</string>
                    <string>cn</string>
                    <string>sn</string>
                    <string>l</string>
                    <string>st</string>
                    <string>title</string>
                    <string>physicalDeliveryOfficeName</string>
                    <string>givenName</string>
                    <string>displayName</string>
                    <string>streetAddress</string>
                    <string>employeeNumber</string>
                    <string>employeeType</string>
                    <string>sAMAccountName</string>
                    <string>mail</string>
                    <string>carLicense</string>
                </fetchedAttributes>
                <getAllFilter><![CDATA[(&(objectClass=user)(sAMAccountType=805306368)(sn=*))]]></getAllFilter>
                <getOneFilter><![CDATA[(&(objectClass=user)(sAMAccountType=805306368)(sn=*)(sAMAccountName={sAMAccountName}))]]></getOneFilter>
                <cleanFilter><![CDATA[(&(objectClass=user)(sAMAccountType=805306368)(sn=*)(sAMAccountName={uid}))]]></cleanFilter>
            </ldapSourceService>
            <ldapDestinationService>
                <name>openldap-dst-service</name>
                <connection reference="ldap-target" />
                <baseDn>dc=my-domain,dc=com</baseDn>
                <pivotAttributes>
                    <string>uid</string>
                </pivotAttributes>
                <fetchedAttributes>
                    <string>dn</string>
                    <string>objectClass</string>
                    <string>cn</string>
                    <string>sn</string>
                    <string>l</string>
                    <string>st</string>
                    <string>title</string>
                    <string>physicalDeliveryOfficeName</string>
                    <string>givenName</string>
                    <string>displayName</string>
                    <string>street</string>
                    <string>employeeNumber</string>
                    <string>employeeType</string>
                    <string>uid</string>
                    <string>mail</string>
                    <string>carLicense</string>
                    <string>userPassword</string>
                </fetchedAttributes>
                <getAllFilter><![CDATA[(objectClass=inetOrgPerson)]]></getAllFilter>
                <getOneFilter><![CDATA[(&(objectClass=inetOrgPerson)(uid={sAMAccountName}))]]></getOneFilter>
            </ldapDestinationService>
            <propertiesBasedSyncOptions>
                <mainIdentifier>srcBean.getMainIdentifier()</mainIdentifier>
                <defaultDelimiter>;</defaultDelimiter>
                <defaultPolicy>FORCE</defaultPolicy>
                <conditions>
                    <create>true</create>
                    <update>true</update>
                    <delete>true</delete>
                    <changeId>true</changeId>
                </conditions>
                <dataset>
                    <name>objectclass</name>
                    <policy>KEEP</policy>
                    <createValues>
                        <string>"inetOrgPerson"</string>
                        <string>"organizationalPerson"</string>
                        <string>"person"</string>
                        <string>"top"</string>
                    </createValues>
                </dataset>
                <dataset>
                    <name>uid</name>
                    <policy>KEEP</policy>
                    <createValues>
                        <string>srcBean.getDatasetFirstValueById("sAMAccountName")</string>
                    </createValues>
                </dataset>
                <dataset>
                    <name>userPassword</name>
                    <policy>KEEP</policy>
                    <createValues>
                        <string>"{SASL}"+srcBean.getDatasetFirstValueById("sAMAccountName")</string>
                    </createValues>
                </dataset>
                <dataset>
                    <name>street</name>
                    <policy>KEEP</policy>
                    <createValues>
                        <string>srcBean.getDatasetFirstValueById("streetAddress")</string>
                    </createValues>
                </dataset>
            </propertiesBasedSyncOptions>
        </task>
    </tasks>
</lsc>
```

### Example of use

Inside container to sync:

```sh
# Sync organizationalUnit
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -c ou -s ou
```

```sh
# Sync users
docker run --rm -it \
-v "$(pwd)/lsc.xml":/etc/lsc/lsc.xml \
jariasl/lsc-project \
-f /etc/lsc -c user -a user
```
