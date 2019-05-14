#!/bin/bash

function theThings()
{
    #getting that UID thing
    note_curl=`curl --silent ${1}'&page=4' | grep -E '(Account:)'`
    #echo $note_curl
    server_uid=$(echo ${note_curl:$(echo `expr index "$note_curl" UID`)} | awk '{print $8}' | cut -d '>' -f2)
    
    #billing call
    billing_curl=$(curl -u dmcdermitt:$(cat ~/Documents/pass.txt) --silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' --data '{"params":{"uniq_id":"'$server_uid'"}}')

    alternate_ssh_port=$(curl -u dmcdermitt:$(cat ~/Documents/pass.txt) --silent "https://api.int.liquidweb.com/bleed/Billing/Subaccnt/Auth/details" --data '{"params":{"uniq_id":"'$server_uid'"}}' | jq -r .alternate_ssh_port)

    account_num=$(echo $billing_curl | jq -r '.accnt')

    account_priority=$(curl -u dmcdermitt:$(cat ~/Documents/pass.txt) --silent "https://api.int.liquidweb.com/bleed/Billing/Account/details" --data '{"params":{"accnt":"'$account_num'"}}' | jq -r .priority)

    server_type=$(echo $billing_curl | jq '.template_description')
 
    if [[ -n "$(echo $server_type | egrep -v "(Win|Self)" | grep CentOS)" ]] && [[ "$( echo $account_priority | grep normal)" ]]
    then
        echo | tee -a completed_list
        echo "==========================================================" | tee -a completed_list | tee -a completed_list
        echo Radar Notes: |  tee -a completed_list
        echo ${1}'&page=4' | tee -a completed_list
        echo Account: $account_num | tee -a completed_list
        echo UID: $server_uid | tee -a completed_list
        echo OS: $server_type | tee -a completed_list
        echo Priority: $account_priority | tee -a completed_list

        server_ip=$(echo $billing_curl | jq -r '.ip')
        server_domain=$(echo $billing_curl | jq -r .domain)
        echo Host: $server_domain | tee -a completed_list
        echo IP: $server_ip | tee -a completed_list
        
        #Try lw-admin first
        auth_curl=$(curl --silent -u dmcdermitt:$(cat ~/Documents/pass.txt) 'https://api.int.liquidweb.com/asset/details.json?uniq_id='${server_uid}'&alsowith%5B%5D=credentials')

        user=$(echo $auth_curl | jq -r .credentials.username)
        pass=$(echo $auth_curl | jq -r .credentials.password)
        port="22"

        if [[ "$(echo $alternate_ssh_port | egrep '[0-9]')" ]]
        then
            port="$alternate_ssh_port"
        fi

        ssh_cmd="ssh $user@$server_ip -p$port"

        if sshpass -p $pass $ssh_cmd exit
        then
            timeout 180 sshpass -p $pass $ssh_cmd 'bash -s' < boot_rotate.sh | tee -a completed_list
        else
            if [[ "$(echo $user | grep -i lw)" ]]
            then
                echo;echo "LW Failed Trying ROOT";echo
                user="root"
                pass=$(echo $billing_curl | jq -r .password)

                ssh_cmd="ssh $user@$server_ip -p$port"

                if sshpass -p $pass $ssh_cmd exit                
                then
                    timeout 180 sshpass -p $pass $ssh_cmd 'bash -s' < boot_rotate.sh | tee -a completed_list
                else
                    echo "LW-Admin Failed and Bad Root Pass" | tee -a completed_list
                fi
            else
                echo "No LW-Admin -- Bad Root Pass" | tee -a completed_list
            fi
        fi
    fi
}

echo "Build new master list (y/n)? "
read build

if [[ "$build" == "y" ]]
then
    cat /dev/null > entire_boot_list
    for i in $(curl --silent 'https://monitor.liquidweb.com/problems.php?reportid=86' | grep -E '(Even|Odd)' | grep note | awk '{print $10}' | cut -d "'" -f2 | cut -d '<' -f1)
    do
        echo https://monitor.liquidweb.com$i | tee -a entire_boot_list
    done
fi

for i in $(cat entire_boot_list)
do
    theThings "$i"
done