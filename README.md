# kubernetes-vdc-network-setup
Terraform to setup an network within VCD to allow deployment of a TKG based Kubernetes cluster.
This setup is a *permissive* from a network security policy perspective. Examine the firewall rules carefully.



## Assumptions

- Deploying clusters to EDCE Brisbane
- No other workload is hosted within the VDC
- Use has direct access to the VCD API.
- VDC has at least two IPs 
- Kubernetes API is presented via an external IP address.

## External IP management for Kubernetes

Under NSX-T a minimum of *at least* two IPs are required: 

- One IP for SNAT for outbound internet access
- One IP for a control plane load balancer. 
- Additional load balanced services will need additional IPs for VIPs.


## How to use this repo

Note: State for this terraform codebase is only setup locally

1. Download the github project
2. Collect the necessary data from VMware cloud director including:
   1. Edge network name
   2. Virtual Data centre name
   3. Public IP ranges allocated to the VDC
   4. Org name
3. Either via a `.tfvars` file or environmental variables override the required [varialbles](https://developer.hashicorp.com/terraform/language/values/variables)
4. Run the terraform to deploy the network configuration e.g.
    1. `terraform init`
    2. `terraform apply`
5. Use the VCD UI to deploy a cluster.
   1. Critical considerations are:
      1. Deploying to the correct network (in this case `kubernetes-network`)
      2. Matching the kubernetes api IP to the same as defined in variables.tf
6. Deploy workload or [Test deployments by using the kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)



