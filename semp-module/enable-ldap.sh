ldap_profile_name="default"
ldap_admin_dn="cn=admin,dc=example,dc=org"
ldap_admin_password="adminpassword"
ldap_server="ldap://openldap:1389"
ldap_search_base_dn="ou=users,dc=example,dc=org"
ldap_search_filter='(&amp;(cn=$CLIENT_USERNAME)(memberOf=cn=$VPN_NAMEVpn,ou=groups,dc=example,dc=org))'

printf "Configuring LDAP profile for client authentication and authorization\n"

printf "Configuring LDAP Server"
post_semp_v1 '<rpc semp-version="soltr/'$semp_v1_version'VMR">
                    <authentication>
                        <ldap-profile>
                            <profile-name>'$ldap_profile_name'</profile-name>
                            <ldap-server>
                                <ldap-host>'$ldap_server'</ldap-host>
                                <server-index>1</server-index>
                            </ldap-server>
                        </ldap-profile>
                    </authentication>
                </rpc>'
echo

printf "Configuring Admin Dn for LDAP Profile"
post_semp_v1 '<rpc semp-version="soltr/'$semp_v1_version'VMR">
                    <authentication>
                        <ldap-profile>
                            <profile-name>'$ldap_profile_name'</profile-name>
                            <admin>
                                <admin-dn>'$ldap_admin_dn'</admin-dn>
                                <admin-password>'$ldap_admin_password'</admin-password>
                            </admin>
                        </ldap-profile>
                    </authentication>
                </rpc>'
echo

printf "Configuring Base Dn Search for LDAP Profile"
post_semp_v1 '<rpc semp-version="soltr/'$semp_v1_version'VMR">
                    <authentication>
                        <ldap-profile>
                            <profile-name>'$ldap_profile_name'</profile-name>
                            <search>
                                <base-dn>
                                    <distinguished-name>'$ldap_search_base_dn'</distinguished-name>
                                </base-dn>
                            </search>
                        </ldap-profile>
                    </authentication>
                </rpc>'
echo

printf "Configuring Filter for LDAP Profile"
post_semp_v1 '<rpc semp-version="soltr/'$semp_v1_version'VMR">
                    <authentication>
                        <ldap-profile>
                            <profile-name>'$ldap_profile_name'</profile-name>
                            <search>
                                <filter>
                                    <filter>'$ldap_search_filter'</filter>
                                </filter>
                            </search>
                        </ldap-profile>
                    </authentication>
                </rpc>'
echo

printf "Configuring Authorization Group for Connectors... "
post_semp2 "/authorizationGroups" \
            '{
                "aclProfileName": "acl-connector",
                "authorizationGroupName": "cn=client-connector,cn=defaultVpn,ou=groups,dc=example,dc=org",
                "clientProfileName": "client-connector",
                "enabled": true,
                "msgVpnName": "'$vpn'"
            }'
echo

printf "Configuring Authorization Group for Default... "
post_semp2 "/authorizationGroups" \
            '{
                "aclProfileName": "default",
                "authorizationGroupName": "cn=defaultVpn,ou=groups,dc=example,dc=org",
                "clientProfileName": "default",
                "enabled": true,
                "msgVpnName": "'$vpn'",
                "orderAfterAuthorizationGroupName": "cn=client-connector,cn=defaultVpn,ou=groups,dc=example,dc=org"
            }'
echo

printf "Enabling LDAP Profile"
post_semp_v1 '<rpc semp-version="soltr/'$semp_v1_version'VMR">
                    <authentication>
                        <ldap-profile>
                            <profile-name>'$ldap_profile_name'</profile-name>
                            <no>
                                <shutdown/>
                            </no>
                        </ldap-profile>
                    </authentication>
                </rpc>'
echo

printf "Setting LDAP Profile As Broker Authentication & Authorization Methods... "
patch_semp ${semp_vpn} \
            '{
                "authenticationBasicEnabled": true,
                "authenticationBasicProfileName": "'$ldap_profile_name'",
                "authenticationBasicType": "ldap",
                "authorizationLdapGroupMembershipAttributeName": "memberOf",
                "authorizationLdapTrimClientUsernameDomainEnabled": false,
                "authorizationProfileName": "'$ldap_profile_name'",
                "authorizationType": "ldap",
                "msgVpnName": "'$vpn'"
            }'
echo