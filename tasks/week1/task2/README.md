# 使用 YAML to Infra 模式创建云 Redis 数据库。
> 1.我选择使用terraform在阿里云安装crossplane
> 2.再YAML to Infra 去腾讯云中创建一个云Redis数据库


## 1.安装Crossplane 
- 安装ecs
- 安装k3s
- 使用helm安装Crossplane

```shell
export TF_VAR_secret_id=xxx
export TF_VAR_secret_key=xxx
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform init
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform plan
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform apply -auto-approve
```
验证
```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# export KUBECONFIG="$(pwd)/config.yaml"
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# kubectl get pods -n crossplane-system
NAME                                      READY   STATUS    RESTARTS   AGE
crossplane-869cdfbcdd-cf9gh               1/1     Running   0          87s
crossplane-rbac-manager-f9458595b-8x9p9   1/1     Running   0          87s
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# 
```



## 2.使用YAML to Infra 模式创建云 Redis 数据库。
- 安装 云厂商对应的 provider
- 创建Kubernetes secret 保存腾讯云的 AK 和 SK
- 创建ProviderConfig  
```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl apply -f crossplane-system/provider-tencentcloud.yaml 


cat>tencent-credentials.json <<EOF 
{
  "secret_id": "",
  "secret_key": "",
  "region": "ap-hongkong"
}
EOF

root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/crossplane-system# kubectl create secret generic tencent-account-creds -n crossplane-system --from-file=credentials=tencent-credentials.json
secret/tencent-account-creds created
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/crossplane-system# kubectl describe secret tencent-account-creds -n crossplane-system
Name:         tencent-account-creds
Namespace:    crossplane-system
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
credentials:  137 bytes




root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl apply -f crossplane-system/ProviderConfig.yaml 
```

- 创建云Redis数据库
```shell
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: example-creds
  namespace: default
type: Opaque
stringData:
  credentials: |
    {
      "username": "admin",
      "password": "t0ps3cr3t11"
    }
EOF

root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl apply -f redis.yaml 
```

```

root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl apply -f redis/
# 查看发现vpc和subnet已经创建成功
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl get managed
NAME                                            READY   SYNCED   EXTERNAL-NAME   AGE
instance.redis.tencentcloud.crossplane.io/foo           False                    71s

NAME                                           READY   SYNCED   EXTERNAL-NAME     AGE
subnet.vpc.tencentcloud.crossplane.io/subnet   True    True     subnet-8fffi4nf   3m57s

NAME                                     READY   SYNCED   EXTERNAL-NAME   AGE
vpc.vpc.tencentcloud.crossplane.io/vpc   True    True     vpc-p1va48nq    6m7s



#手动指定了vpcid和subnetid
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl apply -f redis/instance.yaml 
instance.redis.tencentcloud.crossplane.io/foo configured

# 查看发现确实已经发送了创建instance的请求，代表成功了。
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl get events| grep foo
2m1s        Warning   CannotObserveExternalResource     instance/foo                                          cannot run refresh: refresh failed: Reference to undeclared resource: A managed resource "tencentcloud_subnet" "subnet" has not been declared in the root module....
30s         Normal    CreatedExternalResource           instance/foo                                          Successfully requested creation of external resource
5s          Normal    PendingExternalResource           instance/foo                                          Waiting for external resource existence to be confirmed
```

## 3.销毁
```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2# kubectl delete  -f redis/
instance.redis.tencentcloud.crossplane.io "foo" deleted
subnet.vpc.tencentcloud.crossplane.io "subnet" deleted
vpc.vpc.tencentcloud.crossplane.io "vpc" deleted
```

```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform state list 
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform state rm module.k3s module.crossplane module.argocd
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task2/install/dev# terraform destroy -auto-approve
```

