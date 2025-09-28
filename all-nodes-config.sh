set -e

NODES=(hadoop-test-node01-1 hadoop-test-node02-1 hadoop-test-node03-1 hadoop-test-node04-1)
NODES_STRING=$(IFS=,; echo "${NODES[*]}")
HOST_PUBLIC_KEY="$HOME/.ssh/id_rsa.pub"

for node in "${NODES[@]}";
do
    echo -e ">>> Configuring $node...\n"
    docker exec -i $node bash -c "cat > /tmp/node-config.sh && bash /tmp/node-config.sh" $node $NODES_STRING $HOST_PUBLIC_KEY < node-config.sh &
done

wait
echo ">>> All nodes are configured."
