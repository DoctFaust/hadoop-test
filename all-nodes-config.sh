for node in \
hadoop-test-node01-1
hadoop-test-node02-1 \
hadoop-test-node03-1 \
hadoop-test-node04-1;\
do
    echo -e ">>> Configuring $node...\n"
    docker exec -i $node bash -c "cat > /tmp/node-config.sh && bash /tmp/node-config.sh" < node-config.sh
    echo -e ">>> $node configuration over.\n\n\n"
done
