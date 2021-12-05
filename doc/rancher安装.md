# rancher安装

准备工作

下载安装包，配置服务器，安装docker

~~~
docker pull rancher/rancher:stable
docker tag rancher/rancher:stable 10.7.92.101:5000/app/rancher/rancher:stable
docker push 10.7.92.101:5000/app/rancher/rancher:stable
~~~

## 脚本pullImage.sh

~~~
docker pull busybox
docker pull rancher/calico-cni:v3.13.4
docker pull rancher/calico-cni:v3.16.1
docker pull rancher/calico-ctl:v3.13.4
docker pull rancher/calico-ctl:v3.16.1
docker pull rancher/calico-kube-controllers:v3.13.4
docker pull rancher/calico-kube-controllers:v3.16.1
docker pull rancher/calico-node:v3.13.4
docker pull rancher/calico-node:v3.16.1
docker pull rancher/calico-pod2daemon-flexvol:v3.13.4
docker pull rancher/calico-pod2daemon-flexvol:v3.16.1
docker pull rancher/cluster-proportional-autoscaler:1.7.1
docker pull rancher/cluster-proportional-autoscaler:1.8.1
docker pull rancher/configmap-reload:v0.3.0-rancher2
docker pull rancher/coredns-coredns:1.6.2
docker pull rancher/coredns-coredns:1.6.5
docker pull rancher/coredns-coredns:1.6.9
docker pull rancher/coredns-coredns:1.7.0
docker pull rancher/coreos-etcd:v3.3.15-rancher1
docker pull rancher/coreos-etcd:v3.4.13-rancher1
docker pull rancher/coreos-etcd:v3.4.3-rancher1
docker pull rancher/coreos-flannel:v0.12.0
docker pull rancher/coreos-flannel:v0.13.0-rancher1
docker pull rancher/coreos-kube-state-metrics:v1.9.7
docker pull rancher/coreos-prometheus-config-reloader:v0.38.1
docker pull rancher/coreos-prometheus-operator:v0.38.1
docker pull rancher/eks-operator:v1.0.4
docker pull rancher/flannel-cni:v0.3.0-rancher6
docker pull rancher/fluentd:v0.1.19
docker pull rancher/grafana-grafana:6.7.4
docker pull rancher/grafana-grafana:7.1.5
docker pull rancher/hyperkube:v1.16.15-rancher1
docker pull rancher/hyperkube:v1.17.14-rancher1
docker pull rancher/hyperkube:v1.18.12-rancher1
docker pull rancher/hyperkube:v1.19.4-rancher1
docker pull rancher/istio-1.5-migration:0.1.1
docker pull rancher/istio-citadel:1.5.9
docker pull rancher/istio-coredns-plugin:0.2-istio-1.1
docker pull rancher/istio-galley:1.5.9
docker pull rancher/istio-kubectl:1.4.6
docker pull rancher/istio-kubectl:1.5.10
docker pull rancher/istio-kubectl:1.5.9
docker pull rancher/istio-mixer:1.5.9
docker pull rancher/istio-node-agent-k8s:1.5.9
docker pull rancher/istio-pilot:1.5.9
docker pull rancher/istio-proxyv2:1.5.9
docker pull rancher/istio-sidecar_injector:1.5.9
docker pull rancher/jaegertracing-all-in-one:1.14
docker pull rancher/jenkins-jnlp-slave:3.35-4
docker pull rancher/jetstack-cert-manager-controller:v0.8.1
docker pull rancher/jimmidyson-configmap-reload:v0.3.0
docker pull rancher/k8s-dns-dnsmasq-nanny:1.15.0
docker pull rancher/k8s-dns-dnsmasq-nanny:1.15.10
docker pull rancher/k8s-dns-dnsmasq-nanny:1.15.2
docker pull rancher/k8s-dns-kube-dns:1.15.0
docker pull rancher/k8s-dns-kube-dns:1.15.10
docker pull rancher/k8s-dns-kube-dns:1.15.2
docker pull rancher/k8s-dns-node-cache:1.15.13
docker pull rancher/k8s-dns-node-cache:1.15.7
docker pull rancher/k8s-dns-sidecar:1.15.0
docker pull rancher/k8s-dns-sidecar:1.15.10
docker pull rancher/k8s-dns-sidecar:1.15.2
docker pull rancher/kiali-kiali:v1.17
docker pull rancher/kube-api-auth:v0.1.4
docker pull rancher/kubectl:v1.18.0
docker pull rancher/kubernetes-external-dns:v0.7.3
docker pull rancher/library-nginx:1.19.2-alpine
docker pull rancher/log-aggregator:v0.1.7
docker pull rancher/metrics-server:v0.3.4
docker pull rancher/metrics-server:v0.3.6
docker pull rancher/minio-minio:RELEASE.2020-07-13T18-09-56Z
docker pull rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker pull rancher/nginx-ingress-controller:nginx-0.35.0-rancher2
docker pull rancher/opa-gatekeeper:v3.1.0-beta.7
docker pull rancher/openzipkin-zipkin:2.14.2
docker pull rancher/pause:3.1
docker pull rancher/pause:3.2
docker pull rancher/pipeline-jenkins-server:v0.1.4
docker pull rancher/pipeline-tools:v0.1.15
docker pull rancher/plugins-docker:18.09
docker pull rancher/prom-alertmanager:v0.21.0
docker pull rancher/prom-node-exporter:v1.0.1
docker pull rancher/prom-prometheus:v2.12.0
docker pull rancher/prom-prometheus:v2.18.2
docker pull rancher/prometheus-auth:v0.2.1
docker pull rancher/pstauffer-curl:v1.0.3
docker pull rancher/rke-tools:v0.1.66
docker pull rancher/security-scan:v0.1.14
docker pull rancher/shell:v0.1.5
docker pull rancher/sonobuoy-sonobuoy:v0.16.3
docker pull rancher/system-upgrade-controller:v0.6.2
docker pull rancher/thanosio-thanos:v0.15.0
docker pull rancher/webhook-receiver:v0.2.4
docker pull registry:2
docker pull rancher/rancher-agent:v2.5.3
~~~

## 脚本saveImages.sh

~~~

sudo docker save -o  ./tars/registry:2.tar		registry:2
sudo docker save -o  ./tars/webhook-receiver:v0.2.4.tar		rancher/webhook-receiver:v0.2.4
sudo docker save -o  ./tars/thanosio-thanos:v0.15.0.tar		rancher/thanosio-thanos:v0.15.0
sudo docker save -o  ./tars/system-upgrade-controller:v0.6.2.tar		rancher/system-upgrade-controller:v0.6.2
sudo docker save -o  ./tars/sonobuoy-sonobuoy:v0.16.3.tar		rancher/sonobuoy-sonobuoy:v0.16.3
sudo docker save -o  ./tars/shell:v0.1.5.tar		rancher/shell:v0.1.5
sudo docker save -o  ./tars/security-scan:v0.1.14.tar		rancher/security-scan:v0.1.14
sudo docker save -o  ./tars/rke-tools:v0.1.66.tar		rancher/rke-tools:v0.1.66
sudo docker save -o  ./tars/rancher-agent:v2.5.3.tar		rancher/rancher-agent:v2.5.3
sudo docker save -o  ./tars/pstauffer-curl:v1.0.3.tar		rancher/pstauffer-curl:v1.0.3
sudo docker save -o  ./tars/prom-prometheus:v2.18.2.tar		rancher/prom-prometheus:v2.18.2
sudo docker save -o  ./tars/prom-prometheus:v2.12.0.tar		rancher/prom-prometheus:v2.12.0
sudo docker save -o  ./tars/prom-node-exporter:v1.0.1.tar		rancher/prom-node-exporter:v1.0.1
sudo docker save -o  ./tars/prometheus-auth:v0.2.1.tar		rancher/prometheus-auth:v0.2.1
sudo docker save -o  ./tars/prom-alertmanager:v0.21.0.tar		rancher/prom-alertmanager:v0.21.0
sudo docker save -o  ./tars/plugins-docker:18.09.tar		rancher/plugins-docker:18.09
sudo docker save -o  ./tars/pipeline-tools:v0.1.15.tar		rancher/pipeline-tools:v0.1.15
sudo docker save -o  ./tars/pipeline-jenkins-server:v0.1.4.tar		rancher/pipeline-jenkins-server:v0.1.4
sudo docker save -o  ./tars/pause:3.2.tar		rancher/pause:3.2
sudo docker save -o  ./tars/pause:3.1.tar		rancher/pause:3.1
sudo docker save -o  ./tars/openzipkin-zipkin:2.14.2.tar		rancher/openzipkin-zipkin:2.14.2
sudo docker save -o  ./tars/opa-gatekeeper:v3.1.0-beta.7.tar		rancher/opa-gatekeeper:v3.1.0-beta.7
sudo docker save -o  ./tars/nginx-ingress-controller-defaultbackend:1.5-rancher1.tar		rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
sudo docker save -o  ./tars/nginx-ingress-controller:nginx-0.35.0-rancher2.tar		rancher/nginx-ingress-controller:nginx-0.35.0-rancher2
sudo docker save -o  ./tars/minio-minio:RELEASE.2020-07-13T18-09-56Z.tar		rancher/minio-minio:RELEASE.2020-07-13T18-09-56Z
sudo docker save -o  ./tars/metrics-server:v0.3.6.tar		rancher/metrics-server:v0.3.6
sudo docker save -o  ./tars/metrics-server:v0.3.4.tar		rancher/metrics-server:v0.3.4
sudo docker save -o  ./tars/log-aggregator:v0.1.7.tar		rancher/log-aggregator:v0.1.7
sudo docker save -o  ./tars/library-nginx:1.19.2-alpine.tar		rancher/library-nginx:1.19.2-alpine
sudo docker save -o  ./tars/kubernetes-external-dns:v0.7.3.tar		rancher/kubernetes-external-dns:v0.7.3
sudo docker save -o  ./tars/kubectl:v1.18.0.tar		rancher/kubectl:v1.18.0
sudo docker save -o  ./tars/kube-api-auth:v0.1.4.tar		rancher/kube-api-auth:v0.1.4
sudo docker save -o  ./tars/kiali-kiali:v1.17.tar		rancher/kiali-kiali:v1.17
sudo docker save -o  ./tars/k8s-dns-sidecar:1.15.2.tar		rancher/k8s-dns-sidecar:1.15.2
sudo docker save -o  ./tars/k8s-dns-sidecar:1.15.10.tar		rancher/k8s-dns-sidecar:1.15.10
sudo docker save -o  ./tars/k8s-dns-sidecar:1.15.0.tar		rancher/k8s-dns-sidecar:1.15.0
sudo docker save -o  ./tars/k8s-dns-node-cache:1.15.7.tar		rancher/k8s-dns-node-cache:1.15.7
sudo docker save -o  ./tars/k8s-dns-node-cache:1.15.13.tar		rancher/k8s-dns-node-cache:1.15.13
sudo docker save -o  ./tars/k8s-dns-kube-dns:1.15.2.tar		rancher/k8s-dns-kube-dns:1.15.2
sudo docker save -o  ./tars/k8s-dns-kube-dns:1.15.10.tar		rancher/k8s-dns-kube-dns:1.15.10
sudo docker save -o  ./tars/k8s-dns-kube-dns:1.15.0.tar		rancher/k8s-dns-kube-dns:1.15.0
sudo docker save -o  ./tars/k8s-dns-dnsmasq-nanny:1.15.2.tar		rancher/k8s-dns-dnsmasq-nanny:1.15.2
sudo docker save -o  ./tars/k8s-dns-dnsmasq-nanny:1.15.10.tar		rancher/k8s-dns-dnsmasq-nanny:1.15.10
sudo docker save -o  ./tars/k8s-dns-dnsmasq-nanny:1.15.0.tar		rancher/k8s-dns-dnsmasq-nanny:1.15.0
sudo docker save -o  ./tars/jimmidyson-configmap-reload:v0.3.0.tar		rancher/jimmidyson-configmap-reload:v0.3.0
sudo docker save -o  ./tars/jetstack-cert-manager-controller:v0.8.1.tar		rancher/jetstack-cert-manager-controller:v0.8.1
sudo docker save -o  ./tars/jenkins-jnlp-slave:3.35-4.tar		rancher/jenkins-jnlp-slave:3.35-4
sudo docker save -o  ./tars/jaegertracing-all-in-one:1.14.tar		rancher/jaegertracing-all-in-one:1.14
sudo docker save -o  ./tars/istio-sidecar_injector:1.5.9.tar		rancher/istio-sidecar_injector:1.5.9
sudo docker save -o  ./tars/istio-proxyv2:1.5.9.tar		rancher/istio-proxyv2:1.5.9
sudo docker save -o  ./tars/istio-pilot:1.5.9.tar		rancher/istio-pilot:1.5.9
sudo docker save -o  ./tars/istio-node-agent-k8s:1.5.9.tar		rancher/istio-node-agent-k8s:1.5.9
sudo docker save -o  ./tars/istio-mixer:1.5.9.tar		rancher/istio-mixer:1.5.9
sudo docker save -o  ./tars/istio-kubectl:1.5.9.tar		rancher/istio-kubectl:1.5.9
sudo docker save -o  ./tars/istio-kubectl:1.5.10.tar		rancher/istio-kubectl:1.5.10
sudo docker save -o  ./tars/istio-kubectl:1.4.6.tar		rancher/istio-kubectl:1.4.6
sudo docker save -o  ./tars/istio-galley:1.5.9.tar		rancher/istio-galley:1.5.9
sudo docker save -o  ./tars/istio-coredns-plugin:0.2-istio-1.1.tar		rancher/istio-coredns-plugin:0.2-istio-1.1
sudo docker save -o  ./tars/istio-citadel:1.5.9.tar		rancher/istio-citadel:1.5.9
sudo docker save -o  ./tars/istio-1.5-migration:0.1.1.tar		rancher/istio-1.5-migration:0.1.1
sudo docker save -o  ./tars/hyperkube:v1.19.4-rancher1.tar		rancher/hyperkube:v1.19.4-rancher1
sudo docker save -o  ./tars/hyperkube:v1.18.12-rancher1.tar		rancher/hyperkube:v1.18.12-rancher1
sudo docker save -o  ./tars/hyperkube:v1.17.14-rancher1.tar		rancher/hyperkube:v1.17.14-rancher1
sudo docker save -o  ./tars/hyperkube:v1.16.15-rancher1.tar		rancher/hyperkube:v1.16.15-rancher1
sudo docker save -o  ./tars/grafana-grafana:7.1.5.tar		rancher/grafana-grafana:7.1.5
sudo docker save -o  ./tars/grafana-grafana:6.7.4.tar		rancher/grafana-grafana:6.7.4
sudo docker save -o  ./tars/fluentd:v0.1.19.tar		rancher/fluentd:v0.1.19
sudo docker save -o  ./tars/flannel-cni:v0.3.0-rancher6.tar		rancher/flannel-cni:v0.3.0-rancher6
sudo docker save -o  ./tars/eks-operator:v1.0.4.tar		rancher/eks-operator:v1.0.4
sudo docker save -o  ./tars/coreos-prometheus-operator:v0.38.1.tar		rancher/coreos-prometheus-operator:v0.38.1
sudo docker save -o  ./tars/coreos-prometheus-config-reloader:v0.38.1.tar		rancher/coreos-prometheus-config-reloader:v0.38.1
sudo docker save -o  ./tars/coreos-kube-state-metrics:v1.9.7.tar		rancher/coreos-kube-state-metrics:v1.9.7
sudo docker save -o  ./tars/coreos-flannel:v0.13.0-rancher1.tar		rancher/coreos-flannel:v0.13.0-rancher1
sudo docker save -o  ./tars/coreos-flannel:v0.12.0.tar		rancher/coreos-flannel:v0.12.0
sudo docker save -o  ./tars/coreos-etcd:v3.4.3-rancher1.tar		rancher/coreos-etcd:v3.4.3-rancher1
sudo docker save -o  ./tars/coreos-etcd:v3.4.13-rancher1.tar		rancher/coreos-etcd:v3.4.13-rancher1
sudo docker save -o  ./tars/coreos-etcd:v3.3.15-rancher1.tar		rancher/coreos-etcd:v3.3.15-rancher1
sudo docker save -o  ./tars/coredns-coredns:1.7.0.tar		rancher/coredns-coredns:1.7.0
sudo docker save -o  ./tars/coredns-coredns:1.6.9.tar		rancher/coredns-coredns:1.6.9
sudo docker save -o  ./tars/coredns-coredns:1.6.5.tar		rancher/coredns-coredns:1.6.5
sudo docker save -o  ./tars/coredns-coredns:1.6.2.tar		rancher/coredns-coredns:1.6.2
sudo docker save -o  ./tars/configmap-reload:v0.3.0-rancher2.tar		rancher/configmap-reload:v0.3.0-rancher2
sudo docker save -o  ./tars/cluster-proportional-autoscaler:1.8.1.tar		rancher/cluster-proportional-autoscaler:1.8.1
sudo docker save -o  ./tars/cluster-proportional-autoscaler:1.7.1.tar		rancher/cluster-proportional-autoscaler:1.7.1
sudo docker save -o  ./tars/calico-pod2daemon-flexvol:v3.16.1.tar		rancher/calico-pod2daemon-flexvol:v3.16.1
sudo docker save -o  ./tars/calico-pod2daemon-flexvol:v3.13.4.tar		rancher/calico-pod2daemon-flexvol:v3.13.4
sudo docker save -o  ./tars/calico-node:v3.16.1.tar		rancher/calico-node:v3.16.1
sudo docker save -o  ./tars/calico-node:v3.13.4.tar		rancher/calico-node:v3.13.4
sudo docker save -o  ./tars/calico-kube-controllers:v3.16.1.tar		rancher/calico-kube-controllers:v3.16.1
sudo docker save -o  ./tars/calico-kube-controllers:v3.13.4.tar		rancher/calico-kube-controllers:v3.13.4
sudo docker save -o  ./tars/calico-ctl:v3.16.1.tar		rancher/calico-ctl:v3.16.1
sudo docker save -o  ./tars/calico-ctl:v3.13.4.tar		rancher/calico-ctl:v3.13.4
sudo docker save -o  ./tars/calico-cni:v3.16.1.tar		rancher/calico-cni:v3.16.1
sudo docker save -o  ./tars/calico-cni:v3.13.4.tar		rancher/calico-cni:v3.13.4
sudo docker save -o  ./tars/busybox.tar		busybox

~~~



## 脚本loadImages.sh

~~~

docker load < ./tars/registry:2.tar
docker load < ./tars/webhook-receiver:v0.2.4.tar
docker load < ./tars/thanosio-thanos:v0.15.0.tar
docker load < ./tars/system-upgrade-controller:v0.6.2.tar
docker load < ./tars/sonobuoy-sonobuoy:v0.16.3.tar
docker load < ./tars/shell:v0.1.5.tar
docker load < ./tars/security-scan:v0.1.14.tar
docker load < ./tars/rke-tools:v0.1.66.tar
docker load < ./tars/rancher-agent:v2.5.3.tar
docker load < ./tars/pstauffer-curl:v1.0.3.tar
docker load < ./tars/prom-prometheus:v2.18.2.tar
docker load < ./tars/prom-prometheus:v2.12.0.tar
docker load < ./tars/prom-node-exporter:v1.0.1.tar
docker load < ./tars/prometheus-auth:v0.2.1.tar
docker load < ./tars/prom-alertmanager:v0.21.0.tar
docker load < ./tars/plugins-docker:18.09.tar
docker load < ./tars/pipeline-tools:v0.1.15.tar
docker load < ./tars/pipeline-jenkins-server:v0.1.4.tar
docker load < ./tars/pause:3.2.tar
docker load < ./tars/pause:3.1.tar
docker load < ./tars/openzipkin-zipkin:2.14.2.tar
docker load < ./tars/opa-gatekeeper:v3.1.0-beta.7.tar
docker load < ./tars/nginx-ingress-controller-defaultbackend:1.5-rancher1.tar
docker load < ./tars/nginx-ingress-controller:nginx-0.35.0-rancher2.tar
docker load < ./tars/minio-minio:RELEASE.2020-07-13T18-09-56Z.tar
docker load < ./tars/metrics-server:v0.3.6.tar
docker load < ./tars/metrics-server:v0.3.4.tar
docker load < ./tars/log-aggregator:v0.1.7.tar
docker load < ./tars/library-nginx:1.19.2-alpine.tar
docker load < ./tars/kubernetes-external-dns:v0.7.3.tar
docker load < ./tars/kubectl:v1.18.0.tar
docker load < ./tars/kube-api-auth:v0.1.4.tar
docker load < ./tars/kiali-kiali:v1.17.tar
docker load < ./tars/k8s-dns-sidecar:1.15.2.tar
docker load < ./tars/k8s-dns-sidecar:1.15.10.tar
docker load < ./tars/k8s-dns-sidecar:1.15.0.tar
docker load < ./tars/k8s-dns-node-cache:1.15.7.tar
docker load < ./tars/k8s-dns-node-cache:1.15.13.tar
docker load < ./tars/k8s-dns-kube-dns:1.15.2.tar
docker load < ./tars/k8s-dns-kube-dns:1.15.10.tar
docker load < ./tars/k8s-dns-kube-dns:1.15.0.tar
docker load < ./tars/k8s-dns-dnsmasq-nanny:1.15.2.tar
docker load < ./tars/k8s-dns-dnsmasq-nanny:1.15.10.tar
docker load < ./tars/k8s-dns-dnsmasq-nanny:1.15.0.tar
docker load < ./tars/jimmidyson-configmap-reload:v0.3.0.tar
docker load < ./tars/jetstack-cert-manager-controller:v0.8.1.tar
docker load < ./tars/jenkins-jnlp-slave:3.35-4.tar
docker load < ./tars/jaegertracing-all-in-one:1.14.tar
docker load < ./tars/istio-sidecar_injector:1.5.9.tar
docker load < ./tars/istio-proxyv2:1.5.9.tar
docker load < ./tars/istio-pilot:1.5.9.tar
docker load < ./tars/istio-node-agent-k8s:1.5.9.tar
docker load < ./tars/istio-mixer:1.5.9.tar
docker load < ./tars/istio-kubectl:1.5.9.tar
docker load < ./tars/istio-kubectl:1.5.10.tar
docker load < ./tars/istio-kubectl:1.4.6.tar
docker load < ./tars/istio-galley:1.5.9.tar
docker load < ./tars/istio-coredns-plugin:0.2-istio-1.1.tar
docker load < ./tars/istio-citadel:1.5.9.tar
docker load < ./tars/istio-1.5-migration:0.1.1.tar
docker load < ./tars/hyperkube:v1.19.4-rancher1.tar
docker load < ./tars/hyperkube:v1.18.12-rancher1.tar
docker load < ./tars/hyperkube:v1.17.14-rancher1.tar
docker load < ./tars/hyperkube:v1.16.15-rancher1.tar
docker load < ./tars/grafana-grafana:7.1.5.tar
docker load < ./tars/grafana-grafana:6.7.4.tar
docker load < ./tars/fluentd:v0.1.19.tar
docker load < ./tars/flannel-cni:v0.3.0-rancher6.tar
docker load < ./tars/eks-operator:v1.0.4.tar
docker load < ./tars/coreos-prometheus-operator:v0.38.1.tar
docker load < ./tars/coreos-prometheus-config-reloader:v0.38.1.tar
docker load < ./tars/coreos-kube-state-metrics:v1.9.7.tar
docker load < ./tars/coreos-flannel:v0.13.0-rancher1.tar
docker load < ./tars/coreos-flannel:v0.12.0.tar
docker load < ./tars/coreos-etcd:v3.4.3-rancher1.tar
docker load < ./tars/coreos-etcd:v3.4.13-rancher1.tar
docker load < ./tars/coreos-etcd:v3.3.15-rancher1.tar
docker load < ./tars/coredns-coredns:1.7.0.tar
docker load < ./tars/coredns-coredns:1.6.9.tar
docker load < ./tars/coredns-coredns:1.6.5.tar
docker load < ./tars/coredns-coredns:1.6.2.tar
docker load < ./tars/configmap-reload:v0.3.0-rancher2.tar
docker load < ./tars/cluster-proportional-autoscaler:1.8.1.tar
docker load < ./tars/cluster-proportional-autoscaler:1.7.1.tar
docker load < ./tars/calico-pod2daemon-flexvol:v3.16.1.tar
docker load < ./tars/calico-pod2daemon-flexvol:v3.13.4.tar
docker load < ./tars/calico-node:v3.16.1.tar
docker load < ./tars/calico-node:v3.13.4.tar
docker load < ./tars/calico-kube-controllers:v3.16.1.tar
docker load < ./tars/calico-kube-controllers:v3.13.4.tar
docker load < ./tars/calico-ctl:v3.16.1.tar
docker load < ./tars/calico-ctl:v3.13.4.tar
docker load < ./tars/calico-cni:v3.16.1.tar
docker load < ./tars/calico-cni:v3.13.4.tar
docker load < ./tars/busybox.tar

~~~

## pushImage.sh

~~~
docker tag  rancher/calico-cni:v3.13.4    10.7.92.101:5000/app/rancher/calico-cni:v3.13.4
docker tag  rancher/rancher-agent:v2.5.3    10.7.92.101:5000/app/rancher/rancher-agent:v2.5.3
docker tag  registry:2    10.7.92.101:5000/app/registry:2
docker tag  rancher/webhook-receiver:v0.2.4    10.7.92.101:5000/app/rancher/webhook-receiver:v0.2.4
docker tag  rancher/thanosio-thanos:v0.15.0    10.7.92.101:5000/app/rancher/thanosio-thanos:v0.15.0
docker tag  rancher/system-upgrade-controller:v0.6.2    10.7.92.101:5000/app/rancher/system-upgrade-controller:v0.6.2
docker tag  rancher/sonobuoy-sonobuoy:v0.16.3    10.7.92.101:5000/app/rancher/sonobuoy-sonobuoy:v0.16.3
docker tag  rancher/shell:v0.1.5    10.7.92.101:5000/app/rancher/shell:v0.1.5
docker tag  rancher/security-scan:v0.1.14    10.7.92.101:5000/app/rancher/security-scan:v0.1.14
docker tag  rancher/rke-tools:v0.1.66    10.7.92.101:5000/app/rancher/rke-tools:v0.1.66
docker tag  rancher/pstauffer-curl:v1.0.3    10.7.92.101:5000/app/rancher/pstauffer-curl:v1.0.3
docker tag  rancher/prometheus-auth:v0.2.1    10.7.92.101:5000/app/rancher/prometheus-auth:v0.2.1
docker tag  rancher/prom-prometheus:v2.18.2    10.7.92.101:5000/app/rancher/prom-prometheus:v2.18.2
docker tag  rancher/prom-prometheus:v2.12.0    10.7.92.101:5000/app/rancher/prom-prometheus:v2.12.0
docker tag  rancher/prom-node-exporter:v1.0.1    10.7.92.101:5000/app/rancher/prom-node-exporter:v1.0.1
docker tag  rancher/prom-alertmanager:v0.21.0    10.7.92.101:5000/app/rancher/prom-alertmanager:v0.21.0
docker tag  rancher/plugins-docker:18.09    10.7.92.101:5000/app/rancher/plugins-docker:18.09
docker tag  rancher/pipeline-tools:v0.1.15    10.7.92.101:5000/app/rancher/pipeline-tools:v0.1.15
docker tag  rancher/pipeline-jenkins-server:v0.1.4    10.7.92.101:5000/app/rancher/pipeline-jenkins-server:v0.1.4
docker tag  rancher/pause:3.2    10.7.92.101:5000/app/rancher/pause:3.2
docker tag  rancher/pause:3.1    10.7.92.101:5000/app/rancher/pause:3.1
docker tag  rancher/openzipkin-zipkin:2.14.2    10.7.92.101:5000/app/rancher/openzipkin-zipkin:2.14.2
docker tag  rancher/opa-gatekeeper:v3.1.0-beta.7    10.7.92.101:5000/app/rancher/opa-gatekeeper:v3.1.0-beta.7
docker tag  rancher/nginx-ingress-controller:nginx-0.35.0-rancher2    10.7.92.101:5000/app/rancher/nginx-ingress-controller:nginx-0.35.0-rancher2
docker tag  rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1    10.7.92.101:5000/app/rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker tag  rancher/minio-minio:RELEASE.2020-07-13T18-09-56Z    10.7.92.101:5000/app/rancher/minio-minio:RELEASE.2020-07-13T18-09-56Z
docker tag  rancher/metrics-server:v0.3.6    10.7.92.101:5000/app/rancher/metrics-server:v0.3.6
docker tag  rancher/metrics-server:v0.3.4    10.7.92.101:5000/app/rancher/metrics-server:v0.3.4
docker tag  rancher/log-aggregator:v0.1.7    10.7.92.101:5000/app/rancher/log-aggregator:v0.1.7
docker tag  rancher/library-nginx:1.19.2-alpine    10.7.92.101:5000/app/rancher/library-nginx:1.19.2-alpine
docker tag  rancher/kubernetes-external-dns:v0.7.3    10.7.92.101:5000/app/rancher/kubernetes-external-dns:v0.7.3
docker tag  rancher/kubectl:v1.18.0    10.7.92.101:5000/app/rancher/kubectl:v1.18.0
docker tag  rancher/kube-api-auth:v0.1.4    10.7.92.101:5000/app/rancher/kube-api-auth:v0.1.4
docker tag  rancher/kiali-kiali:v1.17    10.7.92.101:5000/app/rancher/kiali-kiali:v1.17
docker tag  rancher/k8s-dns-sidecar:1.15.2    10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.2
docker tag  rancher/k8s-dns-sidecar:1.15.10    10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.10
docker tag  rancher/k8s-dns-sidecar:1.15.0    10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.0
docker tag  rancher/k8s-dns-node-cache:1.15.7    10.7.92.101:5000/app/rancher/k8s-dns-node-cache:1.15.7
docker tag  rancher/k8s-dns-node-cache:1.15.13    10.7.92.101:5000/app/rancher/k8s-dns-node-cache:1.15.13
docker tag  rancher/k8s-dns-kube-dns:1.15.2    10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.2
docker tag  rancher/k8s-dns-kube-dns:1.15.10    10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.10
docker tag  rancher/k8s-dns-kube-dns:1.15.0    10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.0
docker tag  rancher/k8s-dns-dnsmasq-nanny:1.15.2    10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.2
docker tag  rancher/k8s-dns-dnsmasq-nanny:1.15.10    10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.10
docker tag  rancher/k8s-dns-dnsmasq-nanny:1.15.0    10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.0
docker tag  rancher/jimmidyson-configmap-reload:v0.3.0    10.7.92.101:5000/app/rancher/jimmidyson-configmap-reload:v0.3.0
docker tag  rancher/jetstack-cert-manager-controller:v0.8.1    10.7.92.101:5000/app/rancher/jetstack-cert-manager-controller:v0.8.1
docker tag  rancher/jenkins-jnlp-slave:3.35-4    10.7.92.101:5000/app/rancher/jenkins-jnlp-slave:3.35-4
docker tag  rancher/jaegertracing-all-in-one:1.14    10.7.92.101:5000/app/rancher/jaegertracing-all-in-one:1.14
docker tag  rancher/istio-sidecar_injector:1.5.9    10.7.92.101:5000/app/rancher/istio-sidecar_injector:1.5.9
docker tag  rancher/istio-proxyv2:1.5.9    10.7.92.101:5000/app/rancher/istio-proxyv2:1.5.9
docker tag  rancher/istio-pilot:1.5.9    10.7.92.101:5000/app/rancher/istio-pilot:1.5.9
docker tag  rancher/istio-node-agent-k8s:1.5.9    10.7.92.101:5000/app/rancher/istio-node-agent-k8s:1.5.9
docker tag  rancher/istio-mixer:1.5.9    10.7.92.101:5000/app/rancher/istio-mixer:1.5.9
docker tag  rancher/istio-kubectl:1.5.9    10.7.92.101:5000/app/rancher/istio-kubectl:1.5.9
docker tag  rancher/istio-kubectl:1.5.10    10.7.92.101:5000/app/rancher/istio-kubectl:1.5.10
docker tag  rancher/istio-kubectl:1.4.6    10.7.92.101:5000/app/rancher/istio-kubectl:1.4.6
docker tag  rancher/istio-galley:1.5.9    10.7.92.101:5000/app/rancher/istio-galley:1.5.9
docker tag  rancher/istio-coredns-plugin:0.2-istio-1.1    10.7.92.101:5000/app/rancher/istio-coredns-plugin:0.2-istio-1.1
docker tag  rancher/istio-citadel:1.5.9    10.7.92.101:5000/app/rancher/istio-citadel:1.5.9
docker tag  rancher/istio-1.5-migration:0.1.1    10.7.92.101:5000/app/rancher/istio-1.5-migration:0.1.1
docker tag  rancher/hyperkube:v1.19.4-rancher1    10.7.92.101:5000/app/rancher/hyperkube:v1.19.4-rancher1
docker tag  rancher/hyperkube:v1.18.12-rancher1    10.7.92.101:5000/app/rancher/hyperkube:v1.18.12-rancher1
docker tag  rancher/hyperkube:v1.17.14-rancher1    10.7.92.101:5000/app/rancher/hyperkube:v1.17.14-rancher1
docker tag  rancher/hyperkube:v1.16.15-rancher1    10.7.92.101:5000/app/rancher/hyperkube:v1.16.15-rancher1
docker tag  rancher/grafana-grafana:7.1.5    10.7.92.101:5000/app/rancher/grafana-grafana:7.1.5
docker tag  rancher/grafana-grafana:6.7.4    10.7.92.101:5000/app/rancher/grafana-grafana:6.7.4
docker tag  rancher/fluentd:v0.1.19    10.7.92.101:5000/app/rancher/fluentd:v0.1.19
docker tag  rancher/flannel-cni:v0.3.0-rancher6    10.7.92.101:5000/app/rancher/flannel-cni:v0.3.0-rancher6
docker tag  rancher/eks-operator:v1.0.4    10.7.92.101:5000/app/rancher/eks-operator:v1.0.4
docker tag  rancher/coreos-prometheus-operator:v0.38.1    10.7.92.101:5000/app/rancher/coreos-prometheus-operator:v0.38.1
docker tag  rancher/coreos-prometheus-config-reloader:v0.38.1    10.7.92.101:5000/app/rancher/coreos-prometheus-config-reloader:v0.38.1
docker tag  rancher/coreos-kube-state-metrics:v1.9.7    10.7.92.101:5000/app/rancher/coreos-kube-state-metrics:v1.9.7
docker tag  rancher/coreos-flannel:v0.13.0-rancher1    10.7.92.101:5000/app/rancher/coreos-flannel:v0.13.0-rancher1
docker tag  rancher/coreos-flannel:v0.12.0    10.7.92.101:5000/app/rancher/coreos-flannel:v0.12.0
docker tag  rancher/coreos-etcd:v3.4.3-rancher1    10.7.92.101:5000/app/rancher/coreos-etcd:v3.4.3-rancher1
docker tag  rancher/coreos-etcd:v3.4.13-rancher1    10.7.92.101:5000/app/rancher/coreos-etcd:v3.4.13-rancher1
docker tag  rancher/coreos-etcd:v3.3.15-rancher1    10.7.92.101:5000/app/rancher/coreos-etcd:v3.3.15-rancher1
docker tag  rancher/coredns-coredns:1.7.0    10.7.92.101:5000/app/rancher/coredns-coredns:1.7.0
docker tag  rancher/coredns-coredns:1.6.9    10.7.92.101:5000/app/rancher/coredns-coredns:1.6.9
docker tag  rancher/coredns-coredns:1.6.5    10.7.92.101:5000/app/rancher/coredns-coredns:1.6.5
docker tag  rancher/coredns-coredns:1.6.2    10.7.92.101:5000/app/rancher/coredns-coredns:1.6.2
docker tag  rancher/configmap-reload:v0.3.0-rancher2    10.7.92.101:5000/app/rancher/configmap-reload:v0.3.0-rancher2
docker tag  rancher/cluster-proportional-autoscaler:1.8.1    10.7.92.101:5000/app/rancher/cluster-proportional-autoscaler:1.8.1
docker tag  rancher/cluster-proportional-autoscaler:1.7.1    10.7.92.101:5000/app/rancher/cluster-proportional-autoscaler:1.7.1
docker tag  rancher/calico-pod2daemon-flexvol:v3.16.1    10.7.92.101:5000/app/rancher/calico-pod2daemon-flexvol:v3.16.1
docker tag  rancher/calico-pod2daemon-flexvol:v3.13.4    10.7.92.101:5000/app/rancher/calico-pod2daemon-flexvol:v3.13.4
docker tag  rancher/calico-node:v3.16.1    10.7.92.101:5000/app/rancher/calico-node:v3.16.1
docker tag  rancher/calico-node:v3.13.4    10.7.92.101:5000/app/rancher/calico-node:v3.13.4
docker tag  rancher/calico-kube-controllers:v3.16.1    10.7.92.101:5000/app/rancher/calico-kube-controllers:v3.16.1
docker tag  rancher/calico-kube-controllers:v3.13.4    10.7.92.101:5000/app/rancher/calico-kube-controllers:v3.13.4
docker tag  rancher/calico-ctl:v3.16.1    10.7.92.101:5000/app/rancher/calico-ctl:v3.16.1
docker tag  rancher/calico-ctl:v3.13.4    10.7.92.101:5000/app/rancher/calico-ctl:v3.13.4
docker tag  rancher/calico-cni:v3.16.1    10.7.92.101:5000/app/rancher/calico-cni:v3.16.1


docker push  10.7.92.101:5000/app/rancher/calico-cni:v3.13.4
docker push  10.7.92.101:5000/app/rancher/rancher-agent:v2.5.3
docker push  10.7.92.101:5000/app/registry:2
docker push  10.7.92.101:5000/app/rancher/webhook-receiver:v0.2.4
docker push  10.7.92.101:5000/app/rancher/thanosio-thanos:v0.15.0
docker push  10.7.92.101:5000/app/rancher/system-upgrade-controller:v0.6.2
docker push  10.7.92.101:5000/app/rancher/sonobuoy-sonobuoy:v0.16.3
docker push  10.7.92.101:5000/app/rancher/shell:v0.1.5
docker push  10.7.92.101:5000/app/rancher/security-scan:v0.1.14
docker push  10.7.92.101:5000/app/rancher/rke-tools:v0.1.66
docker push  10.7.92.101:5000/app/rancher/pstauffer-curl:v1.0.3
docker push  10.7.92.101:5000/app/rancher/prometheus-auth:v0.2.1
docker push  10.7.92.101:5000/app/rancher/prom-prometheus:v2.18.2
docker push  10.7.92.101:5000/app/rancher/prom-prometheus:v2.12.0
docker push  10.7.92.101:5000/app/rancher/prom-node-exporter:v1.0.1
docker push  10.7.92.101:5000/app/rancher/prom-alertmanager:v0.21.0
docker push  10.7.92.101:5000/app/rancher/plugins-docker:18.09
docker push  10.7.92.101:5000/app/rancher/pipeline-tools:v0.1.15
docker push  10.7.92.101:5000/app/rancher/pipeline-jenkins-server:v0.1.4
docker push  10.7.92.101:5000/app/rancher/pause:3.2
docker push  10.7.92.101:5000/app/rancher/pause:3.1
docker push  10.7.92.101:5000/app/rancher/openzipkin-zipkin:2.14.2
docker push  10.7.92.101:5000/app/rancher/opa-gatekeeper:v3.1.0-beta.7
docker push  10.7.92.101:5000/app/rancher/nginx-ingress-controller:nginx-0.35.0-rancher2
docker push  10.7.92.101:5000/app/rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker push  10.7.92.101:5000/app/rancher/minio-minio:RELEASE.2020-07-13T18-09-56Z
docker push  10.7.92.101:5000/app/rancher/metrics-server:v0.3.6
docker push  10.7.92.101:5000/app/rancher/metrics-server:v0.3.4
docker push  10.7.92.101:5000/app/rancher/log-aggregator:v0.1.7
docker push  10.7.92.101:5000/app/rancher/library-nginx:1.19.2-alpine
docker push  10.7.92.101:5000/app/rancher/kubernetes-external-dns:v0.7.3
docker push  10.7.92.101:5000/app/rancher/kubectl:v1.18.0
docker push  10.7.92.101:5000/app/rancher/kube-api-auth:v0.1.4
docker push  10.7.92.101:5000/app/rancher/kiali-kiali:v1.17
docker push  10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.2
docker push  10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.10
docker push  10.7.92.101:5000/app/rancher/k8s-dns-sidecar:1.15.0
docker push  10.7.92.101:5000/app/rancher/k8s-dns-node-cache:1.15.7
docker push  10.7.92.101:5000/app/rancher/k8s-dns-node-cache:1.15.13
docker push  10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.2
docker push  10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.10
docker push  10.7.92.101:5000/app/rancher/k8s-dns-kube-dns:1.15.0
docker push  10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.2
docker push  10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.10
docker push  10.7.92.101:5000/app/rancher/k8s-dns-dnsmasq-nanny:1.15.0
docker push  10.7.92.101:5000/app/rancher/jimmidyson-configmap-reload:v0.3.0
docker push  10.7.92.101:5000/app/rancher/jetstack-cert-manager-controller:v0.8.1
docker push  10.7.92.101:5000/app/rancher/jenkins-jnlp-slave:3.35-4
docker push  10.7.92.101:5000/app/rancher/jaegertracing-all-in-one:1.14
docker push  10.7.92.101:5000/app/rancher/istio-sidecar_injector:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-proxyv2:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-pilot:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-node-agent-k8s:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-mixer:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-kubectl:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-kubectl:1.5.10
docker push  10.7.92.101:5000/app/rancher/istio-kubectl:1.4.6
docker push  10.7.92.101:5000/app/rancher/istio-galley:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-coredns-plugin:0.2-istio-1.1
docker push  10.7.92.101:5000/app/rancher/istio-citadel:1.5.9
docker push  10.7.92.101:5000/app/rancher/istio-1.5-migration:0.1.1
docker push  10.7.92.101:5000/app/rancher/hyperkube:v1.19.4-rancher1
docker push  10.7.92.101:5000/app/rancher/hyperkube:v1.18.12-rancher1
docker push  10.7.92.101:5000/app/rancher/hyperkube:v1.17.14-rancher1
docker push  10.7.92.101:5000/app/rancher/hyperkube:v1.16.15-rancher1
docker push  10.7.92.101:5000/app/rancher/grafana-grafana:7.1.5
docker push  10.7.92.101:5000/app/rancher/grafana-grafana:6.7.4
docker push  10.7.92.101:5000/app/rancher/fluentd:v0.1.19
docker push  10.7.92.101:5000/app/rancher/flannel-cni:v0.3.0-rancher6
docker push  10.7.92.101:5000/app/rancher/eks-operator:v1.0.4
docker push  10.7.92.101:5000/app/rancher/coreos-prometheus-operator:v0.38.1
docker push  10.7.92.101:5000/app/rancher/coreos-prometheus-config-reloader:v0.38.1
docker push  10.7.92.101:5000/app/rancher/coreos-kube-state-metrics:v1.9.7
docker push  10.7.92.101:5000/app/rancher/coreos-flannel:v0.13.0-rancher1
docker push  10.7.92.101:5000/app/rancher/coreos-flannel:v0.12.0
docker push  10.7.92.101:5000/app/rancher/coreos-etcd:v3.4.3-rancher1
docker push  10.7.92.101:5000/app/rancher/coreos-etcd:v3.4.13-rancher1
docker push  10.7.92.101:5000/app/rancher/coreos-etcd:v3.3.15-rancher1
docker push  10.7.92.101:5000/app/rancher/coredns-coredns:1.7.0
docker push  10.7.92.101:5000/app/rancher/coredns-coredns:1.6.9
docker push  10.7.92.101:5000/app/rancher/coredns-coredns:1.6.5
docker push  10.7.92.101:5000/app/rancher/coredns-coredns:1.6.2
docker push  10.7.92.101:5000/app/rancher/configmap-reload:v0.3.0-rancher2
docker push  10.7.92.101:5000/app/rancher/cluster-proportional-autoscaler:1.8.1
docker push  10.7.92.101:5000/app/rancher/cluster-proportional-autoscaler:1.7.1
docker push  10.7.92.101:5000/app/rancher/calico-pod2daemon-flexvol:v3.16.1
docker push  10.7.92.101:5000/app/rancher/calico-pod2daemon-flexvol:v3.13.4
docker push  10.7.92.101:5000/app/rancher/calico-node:v3.16.1
docker push  10.7.92.101:5000/app/rancher/calico-node:v3.13.4
docker push  10.7.92.101:5000/app/rancher/calico-kube-controllers:v3.16.1
docker push  10.7.92.101:5000/app/rancher/calico-kube-controllers:v3.13.4
docker push  10.7.92.101:5000/app/rancher/calico-ctl:v3.16.1
docker push  10.7.92.101:5000/app/rancher/calico-ctl:v3.13.4
docker push  10.7.92.101:5000/app/rancher/calico-cni:v3.16.1
~~~

## 脚本run.sh

~~~
docker run --name rancher -d --privileged --restart=unless-stopped -p 80:80 -p 443:443 10.7.92.101:5000/app/rancher/rancher:stable
~~~

运行脚本

~~~
sh run.sh
docker logs -f rancher
~~~

访问地址https://10.7.102.127/

## rancher卸载脚本run.sh

~~~
#vi uninstall.sh
~~~
~~~
#删除所有容器
sudo docker rm -f $(sudo docker ps -qa)

#删除/var/etcd目录
sudo rm -rf /var/etcd

#删除/var/lib/kubelet/目录，删除前先卸载
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}'|sudo grep /var/lib/kubelet);do
 sudo umount $m||true
done
sudo rm -rf /var/lib/kubelet/

#删除/var/lib/rancher/目录，删除前先卸载
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}'|sudo grep /var/lib/rancher);do
 sudo umount $m||true
done
sudo rm -rf /var/lib/rancher/

#删除/run/kubernetes/ 目录
sudo rm -rf /run/kubernetes/

rm -rf /etc/ceph \
   /etc/cni \
   /etc/kubernetes \
   /opt/cni \
   /opt/rke \
   /run/secrets/kubernetes.io \
   /run/calico \
   /run/flannel \
   /var/lib/calico \
   /var/lib/etcd \
   /var/lib/cni \
   /var/lib/kubelet \
   /var/lib/rancher/rke/log \
   /var/log/containers \
   /var/log/pods \
   /var/run/calico


#删除所有的数据卷
sudo docker volume rm $(sudo docker volume ls -q)

#再次显示所有的容器和数据卷，确保没有残留
sudo docker ps -a
sudo docker volume ls

~~~

