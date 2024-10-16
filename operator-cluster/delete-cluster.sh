#First delete the wekacluster in k9s, then patch...

kubectl delete wekacluster cluster1 -n weka-operator-system &
sleep 5
kubectl patch WekaCluster cluster1 -n weka-operator-system --type='merge' -p='{"status":{"overrideGracefulDestroyDuration": "0"}}' --subresource=status

