# This is not meant to run on its own, but extends phase1/gce/configure-vm.sh

TOKEN=$(get_metadata "k8s-kubeadm-token")

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

GCS_PATH="mikedanese-k8s-public/test"

apt-get update
wget --quiet "https://storage.googleapis.com/${GCS_PATH}/build/debs/kubeadm.deb"
wget --quiet "https://storage.googleapis.com/${GCS_PATH}/build/debs/kubectl.deb"
wget --quiet "https://storage.googleapis.com/${GCS_PATH}/build/debs/kubelet.deb"
wget --quiet "https://storage.googleapis.com/${GCS_PATH}/build/debs/kubernetes-cni.deb"
dpkg -i *.deb || true
apt-get install -f -y

systemctl enable kubelet
systemctl start kubelet

case "${ROLE}" in
  "master")
    kubeadm init --discovery "token://${TOKEN}@" --skip-preflight-checks --api-advertise-addresses "$(get_metadata "k8s-advertise-addresses")"
    ;;
  "node")
    MASTER=$(get_metadata "k8s-master-ip")
    kubeadm join --discovery "token://${TOKEN}@${MASTER}:9898" --skip-preflight-checks
    ;;
  *)
    echo invalid phase2 provider.
    exit 1
    ;;
esac
