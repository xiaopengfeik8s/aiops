如果执行
```terraform destroy```
时报错或长时间无法销毁，可以尝试执行
```terraform state rm 'module.k3s'```
命令，然后再执行
```terraform destroy```