# Laravel Deployment

### This is laravel deployment for k8s(kubernetes) or k3s with nginx and php fpm and ci-cd pipeline on gitlab ci.

### How to use
- Open deployment/envs
- Set your secrets in base64 encode in secrets, such as app secret, db password, ...
- Set your envs in config map such as database host, database connection and ...
- Apply envs manifest in your cluster with this command: kubectl apply -f envs.yml
- Just upload your project on gitlab after setting gitlab runner for project and K8S config done
- It will deploy your laravel app and create volumes on K8S

### This Repo contains:
- Laravel version 12
- K8s Deployment
- Gitlab-ci pipeline
- Nginx
- PhpFpm with php version 8.2
- Cron in laravel deployment docker image
- Volumes to store Db and Laravel Storage
