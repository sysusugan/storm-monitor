#!bin/bash
dir=`dirname $0`

while [ 1 ]
do
        echo "==========  "`date`"    ==============="
        nid=`jps -l|grep 'nimbus'|awk '{print $1}'`
        if [ "$nid" = "" ]; then
                echo  'storm nimbus is dead!'
                echo  'trying to start nimbus...'
                nohup storm nimbus >nimbus.log &
                echo 'finish starting!'
        else
                echo "storm nimbus id: $nid"
        fi

        uid=`jps -l|grep 'backtype.storm.ui.core'|awk '{print $1}'`
    if [ "$nid" = "" ]; then
        echo  'storm ui process is dead!'
                echo  'trying to start storm ui'
                nohup storm ui >ui.log &
                echo 'finish starting storm ui!'
    else
        echo "storm ui id: $uid"
    fi 

        sh $dir/storm_manager.sh start

        echo "sleeping 20s..."
        sleep 20
done
