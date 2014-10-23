#!bin/bash

    slaves="storm-node-012 storm-node-013 storm-node-014 storm-node-015 storm-node-016 storm-node-017 storm-node-018 storm-node-019 storm-node-020 storm-node-021  storm-node-022 storm-node-023 storm-node-024 storm-node-025"
storm_dir='/var/storm'

check_supervisors(){
    for node in $slaves
    do 
        ssh  $node <<END
            source /etc/profile
            source ~/.bash_profile
            echo "=== check supervisor on $node..."
           
                        sid=\`jps |grep supervisor |awk '{print \$1}'\`
                        if [ "\$sid" = "" ] ;then
                               echo "supervisor is dead!"
                        else
                               echo "supervisor process id: \$sid"
                        fi

            echo "finishing checking $node's supervisor"
                        echo 
END
    done

}

stop_supervisor(){
        for node in $slaves
        do
                ssh $node <<END
                        source /etc/profile
                        source ~/.bash_profile
                        echo "=== killing supervisor on $node..."
                        jps |grep 'supervisor' |awk '{print \$1}' |xargs kill
                        echo "finishing killing $node's supervisor"
END
        done
}

start_supervisor(){
    for node in $slaves
    do 
        ssh $node <<END
            source /etc/profile
                        source ~/.bash_profile
           
                        sid=\`jps |grep supervisor |awk '{print \$1}'\`
                        echo "=== starting supervisor on $node..."
            if [ "\$sid" = "" ] ;then
                echo "supervisor is dead!"
                               mkdir -p ~/rzx
                    rm -fr $storm_dir/supervisor
                               cd ~/rzx
                    nohup storm supervisor >supervisor.log &
                echo "finishing starting $node's supervisor"
            else
                echo "supervisor process id: \$sid"
            fi

END
                echo

    done

}

#同步配置文件
sync_config(){
    for node in $slaves
    do 
                scp /opt/package/apache-storm-0.9.2-incubating/conf/storm.yaml root@$node:/opt/package/apache-storm-0.9.2-incubating/conf/
        echo "finishing sync $node config!"
    done
}


mytest(){
        for node in $slaves
        do
                ssh $node <<END
                ls
END
        done
}



if [ "$1" = "stop" ] ; then
        stop_supervisor
elif [ "$1" = "start" ]; then
        start_supervisor
elif [ "$1" = "sync" ]; then
        sync_config
elif [ "$1" = "check" ]; then
        check_supervisors
else
        mytest
fi
