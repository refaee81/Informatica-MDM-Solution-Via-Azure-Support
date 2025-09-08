#!/bin/bash
dfs_url=$(sed "s/blob/dfs/" <<< "$storage_container_url")
touch "$tmpdir/test.log"
date >> "$tmpdir/test.log"

# Test SSH availability
echo -n "SSH availability test to $HOSTNAME: " >>  $tmpdir/test.log
# Check if the sshd service is active and running
if [[ $(systemctl is-active sshd.service) == "active" ]]; then
if [[  $(systemctl status sshd.service | grep "Active: active (running)") ]]; then
# Check if port 22 is open and in listening mode
if [[ $(ss -lnt | grep ":22") ]]; then 
echo -e "PASSED!" >>  $tmpdir/test.log
else
echo -e "FAILED." >>  $tmpdir/test.log
fi
fi
fi

# Test Storage Account connectivity
token=$(curl --silent 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fdatalake.azure.net%2F' -H Metadata:true | jq -r '.access_token')
echo -n "Connectivity test to $dfs_url: " >>  $tmpdir/test.log
response=$(curl -H "x-ms-version:2018-11-09" -H "Authorization: Bearer $token" "$dfs_url?resource=filesystem&recursive=true" --silent)
# Check if the response contains "path" (i.e. the request was successful)
if [[ "$response" == *"path"* ]]; then
echo -e "PASSED!" >> $tmpdir/test.log
else
echo -e "FAILED!" >>  $tmpdir/test.log
fi

# Test Agent Registration to MDM
echo -n "Registration test for $HOSTNAME agent with MDM Portal: " >>  $tmpdir/test.log
cd /home/$mdmagentadmin/infaagent/apps/agentcore
if [[ $(./consoleAgentManager.sh isConfigured) == true ]]; then
echo -e "PASSED!" >>  $tmpdir/test.log
else
echo -e "FAILED." >>  $tmpdir/test.log
fi

cd /tmp
echo "Test Log file is $tmpdir/test.log"
