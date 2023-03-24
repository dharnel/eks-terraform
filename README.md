# Deployment to a kubernetes cluster using IAAC approach with a CI/CD pipeline

### Summary of Project
* I built the infrastructure required for this project using terraform on Amazon Web Service(AWS). The infrastructure involves a VPC, subnets, amazon elastic kubernetes service which contains the cluster and nodegroups for scaling the deployment and an Ec2 instance which I used to serve as my CI/CD server.

* The CI/CD pipepline tool I used was Jenkins. This was my first time exploring CI/CD tools and I chose Jenkins for the purpose of this project. The code for setting up Jenkins infrastructure can be found in the Jenkins_server_creation directory.

* The apps deployed in this setup are:
    * Sock-shop app - a microservice demo application, the repository can be found [here](https://github.com/dharnel/microservices-demo)
    * Laravel app - a real world example of laravel application,the repository can be found [here](https://github.com/dharnel/laravel-realworld-example-app)
    * Monitoring tools were also set up using prometheus and grafana
    
* I used an ingress to direct traffic to each application service which then directs the traffic to the pod. All the services were internal and they were used to communicate with the pod and receive traffic from the ingress.

* For controlling internet traffic to the different apps, I made use of an Ingress-Nginx controller which creates a single load balancer and connects them to the different ingresses in each application namespace which reduced deployment cost that would have arrived from creating a load balancer with every service.

* I used let's encrypt to provide HTTPS security for each application and route53 on AWS to direct traffic to the loadbalancer created with Ingress-nginx controller. Each application was given a sub domain and connected to the loadbalancer. Internet traffic to the load balancer from these domains were sorted out by the ingress and directed to the appropriate service and then to the appropriate pods.

* The order of Deployment was specified in a Jenkins file script which was used to build the deployment.

## App Interface
### Laravel app
![Screenshot from 2023-03-24 16-29-49](https://user-images.githubusercontent.com/68646090/227571130-9ccbb021-f29e-4633-b18f-57be05987cbf.png)

### sock-shop app 
![Screenshot from 2023-03-24 16-29-26](https://user-images.githubusercontent.com/68646090/227571138-1daefd7f-6a1c-4a1e-887a-fe25775f3ad1.png)

### Grafana Dashboard
![Screenshot from 2023-03-24 16-31-05](https://user-images.githubusercontent.com/68646090/227571121-fc8a3dbe-e501-4a2f-b5d6-1bd8fb39ed31.png)

