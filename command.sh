docker build -t alfianabdi/sample:v0.3 .
docker build -t alfianabdi/sample:v0.3-multistage -f Dockerfile-multistage .
docker build -t alfianabdi/sample:v0.3-multistage-runtime -f Dockerfile-multistage-runtime .
docker build -t alfianabdi/sample:v0.3-multistage-scratch -f Dockerfile-multistage-scratch .

docker ps -a --format '{{.ID}}' | xargs docker rm -f
docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi

docker push alfianabdi/sample:v0.3-multistage
docker push alfianabdi/sample:v0.3-multistage-runtime
docker push alfianabdi/sample:v0.3-multistage-scratch

docker run -v /c/Users/alfian/.aws/:/home/appuser/.aws:ro -e AWS_PROFILE=${AWS_PROFILE} -d -p 8000:8000 alfianabdi/sample:v0.3
docker run -v /c/Users/alfian/.aws/:/home/appuser/.aws:ro -e AWS_PROFILE=${AWS_PROFILE} -d -p 8000:8000 alfianabdi/sample:v0.3-multistage
docker run -v /c/Users/alfian/.aws/:/home/appuser/.aws:ro -e AWS_PROFILE=${AWS_PROFILE} -d -p 8000:8000 alfianabdi/sample:v0.3-multistage-runtime
docker run -v /c/Users/alfian/.aws/:/home/appuser/.aws:ro -e AWS_PROFILE=${AWS_PROFILE} -d -p 8000:8000 alfianabdi/sample:v0.3-multistage-scratch

aws eks update-kubeconfig --name ${EKS_NAME} --kubeconfig kc.yaml
kubectl run --generator=run-pod/v1 --image=alfianabdi/sample:v0.3-multistage-runtime --port=8000 sample-multistage-runtime
kubectl run --generator=run-pod/v1 --image=alfianabdi/sample:v0.3-multistage-scratch --port=8000 sample-multistage-scratch

kubectl apply -f Pod-runtime.yaml
kubectl apply -f Pod-scratch.yaml

kubectl apply -f Deployment-runtime.yaml
kubectl apply -f Deployment-scratch.yaml

kubeconfig port-forward 