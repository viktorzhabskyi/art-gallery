## Dependencies
* Docker
* make
* aws cli
* terraform

## Steps
1. make builds
2. setup init images on services [here](https://github.com/viktorzhabskyi/art-gallery/blob/main/infra/terraform/ecs.tf#L19) [here](https://github.com/viktorzhabskyi/art-gallery/blob/main/infra/terraform/ecs.tf#L58) [here](https://github.com/viktorzhabskyi/art-gallery/blob/main/infra/terraform/ecs.tf#L108)
3. cd ./infra/terraform
4. login into aws
5. terraform init
6. terraform plan
7. terraform apply 
8. cd dir root
9. make bunch-push
10. relaunch ecs tasks
11. Done