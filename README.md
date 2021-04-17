# CodeDeployPractice

## PreRequirements
- macOS / Linux PC
- AWS Account
    - ACCESS_KEY
    - SECRET_KEY
- Terraform 0.14.10
- Docker
- [ecspresso](https://github.com/kayac/ecspresso) v1.5.0
- [direnv](https://github.com/direnv/direnv)


## 試用環境構築手順

### 1. across (ECR) 構築

```
cd infra/environment/across
vi terraform.tfvars
```

<details><summary>infra/environment/across/terraform.tfvars example</summary>

```
aws_access_key = "<YOUR_ACCESS_KEY>"
aws_secret_key = "<YOUR_SECRET_KEY>"
region = "<YOUR_REGION>"
```

</details>

必要に応じて aws_acm_certificate も追記して作成してください

``` 
terraform init
terraform plan 
terraform apply
```

#### ECR Image Push

``` 
cd app
make build AWS_ACCOUNT_ID=<YOUR_AWS_ACCOUNT_ID>
make tag AWS_ACCOUNT_ID=<YOUR_AWS_ACCOUNT_ID>
make ecr-login AWS_ACCOUNT_ID=<YOUR_AWS_ACCOUNT_ID>
make push AWS_ACCOUNT_ID=<YOUR_AWS_ACCOUNT_ID>
```


### 2. development (VPC-Network, ECS Fargate:clusterまで) 構築

```
cd infra/environment/development
vi terraform.tfvars
```

<details><summary>infra/environment/development/terraform.tfvars example</summary>

```
aws_access_key = "<YOUR_ACCESS_KEY>"
aws_secret_key = "<YOUR_SECRET_KEY>"
region = "<YOUR_REGION>"

account_id = "<YOUR_AWS_ACCOUNT_ID>"

dns_zone_id = "<YOUR_DNS_ZONE_ID>"
wc_certificate_arn = "<YOUR_DNS_CERTIFICATE_ARN>"

ecs_service_name = "maintenance-bg"
```

</details>

``` 
terraform init
terraform plan 
terraform apply
```

Outputs の、特に以下は控えておいてください  
（4. CodeDeploy 構築 のときに必要になります）
- out_alb_listener_primary_arn
- out_alb_listener_secondary_arn


### 3. maintenance-bg ECS Service 登録

```
cd infra/environment/development/ecs/maintenance-blue
vi .envrc
```

<details><summary>infra/environment/development/ecs/maintenance-blue/.envrc example</summary>

```
export AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_KEY>"

export AWS_DEFAULT_REGION="<YOUR_REGION>"

export TF_VAR_ENV_PRODUCT_NAME="dev-codedeploy-practice"
export TF_VAR_ECS_SERVICE_NAME_BG="maintenance-bg"

export ECR_IMAGE_REPO="<YOUR_AWS_ACCOUNT_ID>.dkr.ecr.<YOUR_REGION>.amazonaws.com/codedeploy-practice/maintenance:"
export ECR_IMAGE_TAG="blue"
```

</details>

```
direnv allow

make verify       # ecspresso --config config.yaml verify
make dry-create   # ecspresso --config config.yaml create --dry-run
make create       # ecspresso --config config.yaml create
```

※ 自分の場合、 context deadline exceeded で create FAILED. failed to wait service stable: RequestCanceled: waiter context canceled  
となりましたが maintenance-bg ECS サービスは生成されて実行中のタスクが 1 になっていました


ここで green 用の .envrc も作成しておくと良さそうです

```
cd ../maintenance-green
vi .envrc
```


<details><summary>infra/environment/development/ecs/maintenance-green/.envrc example</summary>

```
export AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_KEY>"

export AWS_DEFAULT_REGION="<YOUR_REGION>"

export TF_VAR_ENV_PRODUCT_NAME="dev-codedeploy-practice"
export TF_VAR_ECS_SERVICE_NAME_BG="maintenance-bg"

export ECR_IMAGE_REPO="<YOUR_AWS_ACCOUNT_ID>.dkr.ecr.<YOUR_REGION>.amazonaws.com/codedeploy-practice/maintenance:"
export ECR_IMAGE_TAG="green"
```

</details>


### 4. CodeDeploy 構築

```
cd infra/environment/development/code_deploy
vi terraform.tfvars
```

<details><summary>infra/environment/development/code_deploy/terraform.tfvars example</summary>

```
aws_access_key = "<YOUR_ACCESS_KEY>"
aws_secret_key = "<YOUR_SECRET_KEY>"
region = "<YOUR_REGION>"

account_id = "<YOUR_AWS_ACCOUNT_ID>"

primary_listener_arn = "<PRIMARY_LISTENER_ARN>"
secondary_listener_arn = "<SECONDARY_LISTENER_ARN>"
tg_blue_name = "dev-codedeploy-practice-blue"
tg_green_name = "dev-codedeploy-practice-green"

ecs_cluster_name = "dev-codedeploy-practice"
ecs_service_name = "maintenance-bg"
```

</details>

``` 
terraform init
terraform plan 
terraform apply
```


## CodeDeploy 初回実行例

```
cd infra/environment/development/ecs/maintenance-green
direnv allow

make verify       # ecspresso --config config.yaml verify
make dry-register # ecspresso --config config.yaml register --dry-run
make register     # ecspresso --config config.yaml register

make appspec      # ecspresso --config config.yaml appspec --task-definition=current

make dry-deploy   # ecspresso --config config.yaml deploy --dry-run --skip-task-definition --latest-task-definition
make deploy       # ecspresso --config config.yaml deploy --skip-task-definition --latest-task-definition
```

AWS マネジメントコンソールの CodeDeploy 管理画面が呼び出されるので  
ブラウザで `<YOUR＿SERVICE＿URL>:8080` で確認の上、  
OKなら トラフィックの再ルーティング  
NGなら デプロイを停止してロールバック   
