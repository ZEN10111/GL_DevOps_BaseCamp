
This  project  create infrastructure(vm and network) on  two platforms - AWS and Azure

Get  project:
```
git clone https://github.com/ZEN10111/GL_DevOps_BaseCamp.git

cd "GL_DevOps_BaseCamp/Task. IaaC tools: Terraform/Hometask6/"

```

Enter AWS credentials on file:

```
nano Modules/AWS/provider.tf
```

```
access_key = "put_access_key"
secret_key = "put_secret_key"

```

Install  Azure CLI 

```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

```

Enter into Azure account

```
az login

```
Generate ssh key

```

ssh-keygen

````
![зображення](https://user-images.githubusercontent.com/97990456/210136241-075d6938-9124-4680-b712-017d8c62f3b1.png)

copy public key to project folder

```
cp ~/.ssh/id_rsa.pub ./ssh_pub_key/

```

Initialize providers

```
terraform init

```

Watch ingrastructure plan

```
terraform plan

```

Apply ingrastructure plan

```
terraform appy

yes

```
Output 

![зображення](https://user-images.githubusercontent.com/97990456/210136328-293d5c0a-08be-44b6-a1e1-5d9b0a339e57.png)

Grafana
![зображення](https://user-images.githubusercontent.com/97990456/210135597-f1ff2aff-1108-4947-8f13-c49a97e15562.png)
![зображення](https://user-images.githubusercontent.com/97990456/210135628-a8661746-e3c2-4fdb-b3be-17e3347bf18a.png)

Enter to instances via ssh using single ssh private  key

```

ssh -i ~/.ssh/id_rsa ubuntu@18.156.174.155
ssh -i ~/.ssh/id_rsa ubuntu@20.251.56.46

```

If  you  want to change  some  parameters you may do thit  in  Hometask6/main.tf

```
module "aws_grafana" {
    source ="./Modules/AWS"
  # AWS module configurations 
  #region        = "eu-central-1"
  #instance_type = "t2.micro"
  #key_name      = "id_rsa"
  #ssh_pub_key   = "ssh_pub_key/id_rsa.pub"
  #ami           = "ami-09c5ba4f838d8684a"

}

module "azure_grafana" {
    source ="./Modules/Azure"
  # Azure module configurations 
  #prefix                  = "Grafana"
  #location                = "Norway East"
  #vm_size                 = "Standard_D2s_v3"
  #vm_admin_username       = "ubuntu"
  #ssh_pub_key             = "ssh_pub_key/id_rsa.pub"
  #distr_publisher         = "Canonical"
  #distr_offer             = "UbuntuServer"
  #distr_sku               = "18.04-LTS"
  #distr_version           = "latest"

}
```

To delete all created resources run

```
terraform destroy

yes
```
