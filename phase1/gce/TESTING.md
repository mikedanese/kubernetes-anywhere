Test commands:
```
go run hack/e2e.go -kubernetes-anywhere-cluster=k-a -kubernetes-anywhere-path ../kubernetes-anywhere -kubernetes-anywhere-phase2-provider=kubeadm -deployment kubernetes-anywhere -v -up
kubectl apply -f https://git.io/weave-kube
go run hack/e2e.go -kubernetes-anywhere-cluster=k-a -kubernetes-anywhere-path ../kubernetes-anywhere -kubernetes-anywhere-phase2-provider=kubeadm -deployment kubernetes-anywhere -v -test_args='--ginkgo.focus=.*Conformance.*' -test
go run hack/e2e.go -kubernetes-anywhere-cluster=k-a -kubernetes-anywhere-path ../kubernetes-anywhere -kubernetes-anywhere-phase2-provider=kubeadm -deployment kubernetes-anywhere -v -down
```
