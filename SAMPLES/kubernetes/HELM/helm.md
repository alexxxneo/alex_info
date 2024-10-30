Установка helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

helm pull ingress-nginx/ingress-nginx --version 4.0.6 --untar