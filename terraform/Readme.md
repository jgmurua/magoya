# Terraform para crear un cluster EKS en AWS

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Obtener access key y secret key del usuario cicd los cuales seran usados en github actions

```bash
cd terraform
terraform output cicd_access_key_id
terraform output cicd_secret_access_key
```

## Para crear el kubeconfig local ejecutar

```bash
aws eks --region us-east-1 update-kubeconfig --name eks-simple
```

# Patch aws-auth configmap para permitir acceso al usuario cicd al cluster

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::XXXXXXXXXXXX:role/eksWorkerNodeRole
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::XXXXXXXXXXXX:user/cicd
      username: cicd
      groups:
        - system:masters
EOF
```