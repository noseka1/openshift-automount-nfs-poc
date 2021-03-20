# openshift-automount-nfs-poc

This repo uses openshift-toolbox image

## Deploying POC

```
$ oc apply --kustomize namespace
```

```
$ oc apply --kustomize nfs-server
```

Obtain the IP address of the NFS server

```
$ oc get svc --namespace automount-nfs-poc nfs-server --output jsonpath='{.spec.clusterIP}'
```

Update the NFS IP address:

```
$ vi automount/extra.nfs
```

Deploy automount daemonset:

```
$ oc apply -k automount
```

Deploy a test pod:

```
$ oc apply --kustomize test-pod
```

##Cleaning up

```
$ oc delete --kustomize namespace
```

## References

* [Kubernetes Mount Propagation](https://medium.com/kokster/kubernetes-mount-propagation-5306c36a4a2d)
* [Mount propagation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation)
