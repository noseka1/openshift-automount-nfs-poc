# Automounting NFS on OpenShift

This *proof of concept* shows how to automount NFS shares on OpenShift.

This repo uses [openshift-toolbox](https://github.com/noseka1/openshift-toolbox) image.

## Deploying POC

Create a namespace where everything else will be deployed to:

```
$ oc apply --kustomize namespace
```

Unless you are bringing your own NFS server, you can deploy one on OpenShift:

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

## Cleaning up

```
$ oc delete --kustomize namespace
```

## TODO

* Automount doesn't seem to unmount unused volumes after a timeout

## References

* [Kubernetes Mount Propagation](https://medium.com/kokster/kubernetes-mount-propagation-5306c36a4a2d)
* [Mount propagation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation)
