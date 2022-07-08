# Build the image

### build container image, name it 'goserver'
```
% docker build -t goserver .
```

### Run once on Docker
```
% docker run --rm -p 8080:8080 goserver
```

### Query it
```
% curl http://localhost:8080
Hello, my name is serverbot! I'm running from instance '111a87f36f09'
```
# Pod Example

## Simple
```
We have already built the image, and the YAML references it by name, so we can just apply
```

### Run on Kubernetes, using a NodePort service endpoint
```
% kubectl apply -f simple-pod.yaml
```

### Confirm it is running
```
% kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE     IP         NODE             NOMINATED NODE   READINESS GATES
gopod   1/1     Running   0          3m23s   10.1.0.8   docker-desktop   <none>           <none>

% kubectl get services -o wide
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE     SELECTOR
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          4h26m   <none>
the-server-service   NodePort    10.100.127.12   <none>        8080:30080/TCP   3m34s   app=the-go-pod
```

### Query it
```
% curl http://localhost:30080
Hello, my name is serverbot!  I'm running from instance 'gopod'
```

### clean up
```
% kubectl delete -f simple-pod.yaml
```

## Advanced
### More advanced config using configmap and secret
```
% kubectl apply -f pod-with-config.yaml
```

### Confirm new secrets and config
```
% kubectl get configmaps -o wide
NAME               DATA   AGE
kube-root-ca.crt   1      4h31m
server-config      1      3m40s

% kubectl get secrets
NAME            TYPE     DATA   AGE
server-secret   Opaque   1      5s
```

### Check it
```
% curl http://localhost:30080
Hello, my name is Frank! I'm running from instance 'gopod'

% kubectl exec -it gopod -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=gopod
TERM=xterm
SERVERNAME=Frank

% kubectl exec -it gopod -- cat /secrets/password
password%
```

### clean up
```
% kubectl delete -f pod-with-config.yaml
pod "gopod" deleted
service "the-server-service" deleted
configmap "server-env" deleted
secret "server-secret" deleted
```

## Deployment example

Deployments allow for multiple identical instances of a pod, using a 'template' of a PodSpec

### Apply the deployment and its config
```
% kubectl apply -f deployment-with-config.yaml
deployment.apps/the-go-deployment created
service/the-server-service created
configmap/server-env created
secret/server-secret created
```

### Check, see we have three of our pods now
```
% kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
the-go-deployment-6648887b44-2dqdr   1/1     Running   0          23s
the-go-deployment-6648887b44-4j8ws   1/1     Running   0          23s
the-go-deployment-6648887b44-8gvng   1/1     Running   0          23s
```

### Query it, see the service redirects to different pods
```
% curl http://localhost:30080
Hello, my name is Frank! I'm running from instance 'the-go-deployment-6648887b44-8gvng'

% curl http://localhost:30080
Hello, my name is Frank! I'm running from instance 'the-go-deployment-6648887b44-4j8ws'
```

### Inspect the endpoints that the service found to redirect to - these are our three pod IPs
```
% kubectl get endpoints
NAME                 ENDPOINTS                                      AGE
kubernetes           192.168.65.4:6443                              4h48m
the-server-service   10.1.0.16:8080,10.1.0.17:8080,10.1.0.18:8080   90s

% kubectl get pods -o wide
NAME                                 READY   STATUS    RESTARTS   AGE    IP          NODE             NOMINATED NODE   READINESS GATES
the-go-deployment-6648887b44-2dqdr   1/1     Running   0          2m4s   10.1.0.18   docker-desktop   <none>           <none>
the-go-deployment-6648887b44-4j8ws   1/1     Running   0          2m4s   10.1.0.17   docker-desktop   <none>           <none>
the-go-deployment-6648887b44-8gvng   1/1     Running   0          2m4s   10.1.0.16   docker-desktop   <none>           <none>
```

### clean up
```
% kubectl delete -f deployment-with-config.yaml
deployment.apps "the-go-deployment" deleted
service "the-server-service" deleted
configmap "server-env" deleted
secret "server-secret" delete
```

## Namespaces

Namespaces are just ways to categorize resources and attach RBAC to them. Usually different applications 
can be split into namespaces for organizational purposes.

### Create a namespace
```
% kubectl create namespace goserver
namespace/goserver created
```

### deployment to a specifc namespace. Note that 'namespace' can also be set in the yaml 'metadata'
```
% kubectl -n goserver apply -f deployment-with-config.yaml
deployment.apps/the-go-deployment created
service/the-server-service created
configmap/server-env created
secret/server-secret created
```

### Check 
```
% kubectl get pods
No resources found in default namespace.
```

### Oops! We deployed to a specific namespace. Query that instead
```
% kubectl -n goserver get pods
NAME                                 READY   STATUS    RESTARTS   AGE
the-go-deployment-6648887b44-4vllq   1/1     Running   0          14s
the-go-deployment-6648887b44-ll8mr   1/1     Running   0          14s
the-go-deployment-6648887b44-pcxjd   1/1     Running   0          14s
```

### Clean up
```
% kubectl -n goserver delete -f deployment-with-config.yaml
deployment.apps "the-go-deployment" deleted
service "the-server-service" deleted
configmap "server-env" deleted
secret "server-secret" deleted
```
