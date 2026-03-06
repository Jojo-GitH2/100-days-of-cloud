# 100 Days of Cloud Challenge

**Start Date:** January 1, 2026  
**End Date:** April 10, 2026  
**Status:** 🟢 Active  
**Author:** Jonah Uka | Cloud DevOps Engineer & .NET Developer

## 📅 Daily Log

### AWS

### 🗓️ Day 1: Create a Key Pair

**Date:** Jan 1, 2026

- **Activity:** Create SSH key pairs for secure access to EC2 instances via the AWS Console
- **Lab:** [Go to Day-001](./Day-001)
- **Thoughts:** Creating a key pair is straightforward via the AWS Console. It’s essential for secure access to EC2 instances.

---

### 🗓️ Day 2: Create Security Groups

**Date:** Jan 2, 2026

- **Activity:** Create virtual firewalls (Security Groups) to manage inbound and outbound traffic for EC2 instances using both AWS Console and AWS CLI
- **Lab:** [Go to Day-002](./Day-002)
- **Thoughts:** Security Groups are stateful, meaning if you allow a request in, the response is automatically allowed out. This makes them easier to manage than stateless ACLs for instance-level security.

---

### 🗓️ Day 3: Create Subnets & Understand CIDR

**Date:** Jan 3, 2026

- **Activity:** Partition a VPC into subnets and understand CIDR notation using both AWS Console and AWS CLI
- **Lab:** [Go to Day-003](./Day-003)
- **Thoughts:** The hardest part isn't creating the subnet, it's the CIDR math. Also learned a valuable lesson about quoting JSON in CLI commands to avoid parsing errors.

---

### 🗓️ Day 4: Allocate Elastic IP

**Date:** Jan 4, 2026

- **Activity:** Allocate an Elastic IP address using both AWS Console and AWS CLI
- **Lab:** [Go to Day-004](./Day-004)
- **Thoughts:** Allocating an Elastic IP is a simple process, but it's important to understand the implications of using one.

---

### 🗓️ Day 5: Create GP3 Volume

**Date:** Jan 5, 2026

- **Activity:** Provisioned a standalone General Purpose SSD (gp3) volume using Console and CLI.
- **Lab:** [Go to Day-005](./Day-005)
- **Thoughts:** EBS Volumes are very important in the AWS cloud architecture. They can be used as primary storage for data that requires frequent updates, such as the system drive for an instance or storage for a database application.

---

### 🗓️ Day 6: Launch EC2 Instance

**Date:** Jan 6,2026

- **Activity:** Launched a t2.micro instance, integration the key pair, Security Group, and Subnet.
- **Lab:** [Go to Day-006](./Day-006)
- **Thoughts:** It's satisfying to see the previous days' work connect. The instance is useless without the network (Subnet) and access (Key Pair & Security Group).

---

### 🗓️ Day 7: Change EC2 Instance Type

**Date:** Jan 7, 2026

- **Activity:** Performed "Right-Sizing" via the AWS Console by scaling an instance down from t2.micro to t2.nano to optimize costs.
- **Lab:** [Go to Day-007](./Day-007)
- **Thoughts:** Vertical scaling requires stopping the machine. It’s a simple process in the Console, but critical to remember that you can't change the engine while the car is moving.

---

### 🗓️ Day 8: Enable Stop Protection

**Date:** Jan 8, 2026

- **Activity:** Enabled "Stop Protection" on the nautilus-ec2 instance to prevent accidental shutdowns via Console or API.
- **Lab:** [Go to Day-008](./Day-008)
- **Thoughts:** A small checkbox that saves big headaches. It’s distinct from Termination Protection, and highly useful for avoiding "fat finger" mistakes in production.

---

### 🗓️ Day 9: Enable Termination Protection

**Date:** Jan 9, 2026

- **Activity:** Enabled "Termination Protection" to prevent the permanent deletion of critical EC2 instances.
- **Lab:** [Go to Day-009](./Day-009)
- **Thoughts:** The difference between "Stop" and "Terminate" is the difference between turning off the lights and burning down the house. This setting is a must for production databases and critical servers.

---

### 🗓️ Day 10: Attach Elastic IP

**Date:** Jan 10, 2026

- **Activity:** Associated a static Elastic IP to the `datacenter-ec2` instance to ensure a permanent network identity.
- **Lab:** [Go to Day-010](./Day-010)
- **Thoughts:** This closes the loop from Day 4. Not only does this secure a permanent address for the server, but attaching it to a running instance also stops the hourly "idle IP" charge from AWS.

---

### 🗓️ Day 11: Attach Elastic Network Interface (ENI)

**Date:** Jan 11, 2026

- **Activity:** Attached a secondary Elastic Network Interface (ENI) to the `devops-ec2` instance.
- **Lab:** [Go to Day-011](./Day-011)
- **Thoughts:** An ENI is just a virtual network card. Adding a second one allows for interesting architectures, like separating management traffic from user traffic or creating low-budget high-availability setups.

---

### 🗓️ Day 12: Attach EBS Volume

**Date:** Jan 12, 2026

- **Activity:** Attached a secondary EBS volume (`devops-volume`) to the `devops-ec2` instance as `/dev/sdb`.
- **Lab:** [Go to Day-012](./Day-012)
- **Thoughts:** This is "Hot-Plugging" in the cloud. The critical constraint to remember is the Availability Zone—you can't attach a hard drive if the server is in a different building!

---

### 🗓️ Day 13: Create AMI (Golden Image)

**Date:** Jan 13, 2026

- **Activity:** Created a custom Amazon Machine Image (AMI) named `nautilus-ec2-ami` from a running instance to enable cloning and backup.
- **Lab:** [Go to Day-013](./Day-013)
- **Thoughts:** This is essentially "Save Game" for servers. It captures the OS, the data, and the config, allowing you to spawn identical copies instantly.

---

### 🗓️ Day 14: Terminate EC2 Instance

**Date:** Jan 14, 2026

- **Activity:** Permanently terminated the obsolete `datacenter-ec2` instance to optimize costs and remove unused resources.
- **Lab:** [Go to Day-014](./Day-014)
- **Thoughts:** Deletion is the final step of the lifecycle. It’s crucial to distinguish between "Stopping" (pausing billing for compute) and "Terminating" (destroying the resource entirely).

---

### 🗓️ Day 15: Create Volume Snapshot

**Date:** Jan 15, 2026

- **Activity:** Created a point-in-time backup (Snapshot) of the `nautilus-vol` volume for disaster recovery purposes.
- **Lab:** [Go to Day-015](./Day-015)
- **Thoughts:** Snapshots are the backbone of data protection in AWS. The fact that they are incremental makes them a very cost-effective way to keep a history of your changes.

---

### 🗓️ Day 16: Create IAM User

**Date:** Jan 16, 2026

- **Activity:** Created an IAM user (`iamuser_javed`) to establish individual identity and avoid using the root account.
- **Lab:** [Go to Day-016](./Day-016)
- **Thoughts:** Identity is the new perimeter. Creating users is the first step in the "Principle of Least Privilege." We grant access only to specific people, not generic shared accounts.

---

### 🗓️ Day 17: Create IAM Group

**Date:** Jan 17, 2026

- **Activity:** Created an IAM group (`iamgroup_james`) to facilitate scalable permission management.
- **Lab:** [Go to Day-017](./Day-017)
- **Thoughts:** This is about efficiency. Managing permissions at the Group level is the only way to stay sane in a large organization. It ensures that everyone with the same role has the exact same access.

### 🗓️ Day 18: Create Read-Only Policy

**Date:** Jan 18, 2026

- **Activity:** Created a custom IAM policy (`iampolicy_mariyam`) that grants read-only access to the EC2 console using the `ec2:Describe*` action.
- **Lab:** [Go to Day-018](./Day-018)
- **Thoughts:** This is the core of custom security. Instead of handing out full Admin rights, we wrote a specific rule that says "You can look, but you can't touch."

---

### 🗓️ Day 19: Attach IAM Policy

**Date:** Jan 19, 2026

- **Activity:** Connected an existing IAM Policy (`iampolicy_ravi`) to an IAM User (`iamuser_ravi`) to grant active permissions.
- **Lab:** [Go to Day-019](./Day-019)
- **Thoughts:** A user without a policy is powerless. A policy without a user is useless. Today was about making the connection between "Who" (The User) and "What" (The Rules).

---

### 🗓️ Day 20: Create IAM Role

**Date:** Jan 20, 2026

- **Activity:** Created an IAM Role (`iamrole_yousuf`) for EC2 and attached a policy, enabling secure, keyless access.
- **Lab:** [Go to Day-020](./Day-020)
- **Thoughts:** This is the most secure way to handle credentials on servers. Hardcoding Access Keys is a sin; using Roles is salvation.

---

### 🗓️ Day 21: EC2 with Elastic IP

**Date:** Jan 21, 2026

- **Activity:** Provisioned a new `t2.micro` instance (`devops-ec2`) and immediately assigned a static Elastic IP (`devops-eip`) to ensure consistent access.
- **Lab:** [Go to Day-021](./Day-021)
- **Thoughts:** This combines the skills from Day 6 (Launch) and Day 10 (EIP). It’s a standard pattern for single-instance application deployments where DNS stability is required.

---

### 🗓️ Day 22: Secure SSH Configuration

**Date:** Jan 22, 2026

- **Activity:** Configured passwordless SSH access by injecting the `aws-client` public key into the `nautilus-ec2` instance using an **EC2 User Data** script.
- **Lab:** [Go to Day-022](./Day-022)
- **Thoughts:** Using User Data to inject keys is a pro move. It completely removes the need for manual setup or temporary key pairs. The instance is ready to accept connections the moment it boots.

---

### 🗓️ Day 23: S3 Data Migration

**Date:** Jan 23, 2026

- **Activity:** Migrated data between two S3 buckets using the AWS CLI `sync` command for efficiency and consistency.
- **Lab:** [Go to Day-023](./Day-023)
- **Thoughts:** The `aws s3 sync` command is one of the most powerful tools in the CLI. It's idempotent, meaning you can run it 100 times safely. It's the standard for simple bucket-to-bucket migrations.

---

### 🗓️ Day 24: Application Load Balancer

**Date:** Jan 24, 2026

- **Activity:** Deployed an Application Load Balancer (`xfusion-alb`) to route traffic to an EC2 instance, implementing Security Group Chaining for protection.
- **Lab:** [Go to Day-024](./Day-024)
- **Thoughts:** The coolest part was chaining the Security Groups. Making the EC2 instance only listen to the ALB (and ignoring the rest of the internet) feels like a massive security win.

---

### 🗓️ Day 25: CloudWatch Alarm

**Date:** Jan 25, 2026

- **Activity:** Launched `devops-ec2` and configured a CloudWatch Alarm (`devops-alarm`) to trigger an SNS notification if CPU usage exceeds 90%.
- **Lab:** [Go to Day-025](./Day-025)
- **Thoughts:** Monitoring is what separates hobbyists from professionals. You can't fix what you can't see. Setting up this alarm ensures the system screams for help before it crashes.

---

### 🗓️ Day 26: Nginx Web Server (User Data)

**Date:** Jan 26, 2026

- **Activity:** Provisioned an Ubuntu EC2 instance and used a User Data script to automatically install and start Nginx.
- **Lab:** [Go to Day-026](./Day-026)
- **Thoughts:** Bootstrapping removes the need for SSH. If you find yourself logging into a server to run `apt install`, you are doing it manually. User Data automates the "Day 1" setup.

---

### 🗓️ Day 27: Custom Public VPC

**Date:** Jan 27, 2026

- **Activity:** Built a custom VPC (`xfusion-pub-vpc`) with a public subnet, Internet Gateway, and Route Table, then launched an accessible EC2 instance.
- **Lab:** [Go to Day-027](./Day-027)
- **Thoughts:** This is the "Hello World" of Cloud Networking. Understanding the relationship between the IGW, Route Table, and Subnet is the most critical concept in AWS networking.

---

### 🗓️ Day 28: Amazon ECR

**Date:** Jan 28, 2026

- **Activity:** Created a private ECR repository (`xfusion-ecr`), built a Docker image from a local Dockerfile, and pushed it to the registry.
- **Lab:** [Go to Day-028](./Day-028)
- **Thoughts:** The hardest part of ECR is usually the authentication command. Once you understand that you are piping a token into `docker login`, the rest is standard Docker workflow.

---

### 🗓️ Day 29: VPC Peering

**Date:** Jan 29, 2026

- **Activity:** Established a peering connection between a Public and Private VPC (`devops-vpc-peering`), configured route tables, and used EC2 Instance Connect to manually authorize SSH access.
- **Lab:** [Go to Day-029](./Day-029)
- **Thoughts:** Peering is the "Secret Tunnel" of AWS. The Instance Connect workaround was a lifesaver for accessing an existing instance without a key pair.

---

### 🗓️ Day 30: NAT Instance

**Date:** Jan 30, 2026

- **Activity:** Configured a "Poor Man's NAT Gateway" using an EC2 instance. Set up `igw-devops`, public routing, and `iptables` rules to route private traffic to the internet.
- **Lab:** [Go to Day-030](./Day-030)
- **Thoughts:** The `iptables` command requires knowing your interface name! I used `ens5` in my script. Also, never forget that the Public Subnet needs an actual Internet Gateway (`igw-devops`) to function.

---

**Date:** Jan 31, 2026

- **Activity:** Provisioned a Private MySQL RDS instance (`xfusion-rds`) with Storage Autoscaling enabled to prevent capacity issues during development.
- **Lab:** [Go to Day-031](./Day-031)
- **Thoughts:** The `db.t3.micro` is a workhorse for dev environments. Enabling autoscaling (even with a small cap like 50GB) is a best practice that saves you from waking up to a "Disk Full" error.

---

### 🗓️ Day 32: RDS Backup & Restore

**Date:** Feb 01, 2026

- **Activity:** Took a manual snapshot of an RDS instance and restored it to a new `db.t3.micro` instance to verify data integrity and backup procedures.
- **Lab:** [Go to Day-032](./Day-032)
- **Thoughts:** The ability to resize an instance _during_ the restore process is a powerful feature. It allows you to take a snapshot of a massive Production DB and restore it to a tiny Dev instance for debugging.

---

### 🗓️ Day 33: AWS Lambda

**Date:** Feb 02, 2026

- **Activity:** Created a Python Lambda function (`devops-lambda`) with a custom IAM role to return a JSON response.
- **Lab:** [Go to Day-033](./Day-033)
- **Thoughts:** This is the entry point to modern cloud architecture. No OS patching, no SSH, just code and execution. The speed from "Idea" to "Running" is unmatched.

---

### 🗓️ Day 34: AWS Lambda via CLI

**Date:** Feb 03, 2026

- **Activity:** Packaged a Python script into a zip file and deployed it as a Lambda function (`datacenter-lambda-cli`) using the AWS CLI.
- **Lab:** [Go to Day-034](./Day-034)
- **Thoughts:** The AWS CLI forces you to understand the components (Role ARNs, Handlers, Zip packages) better than the Console wizard does. The `fileb://` prefix is a classic CLI "gotcha", but once understood, it makes binary uploads seamless.

---

### 🗓️ Day 35: LAMP Stack Deployment

**Date:** Feb 04, 2026

- **Activity:** Deployed a PHP application on EC2 connected to a Private MySQL RDS. Troubleshot SSH permissions, reset DB credentials, and fixed Apache directory prioritization.
- **Lab:** [Go to Day-035](./Day-035)
- **Thoughts:** A perfect deployment is rare. I had to reset the RDS password, add a missing SSH rule to the Security Group, and modify `dir.conf` to get the page loading correctly.

### 🗓️ Day 36: Application Load Balancer

**Date:** Feb 05, 2026

- **Activity:** Deployed an Nginx web server behind an Application Load Balancer (`xfusion-alb`). Configured Security Group referencing so the EC2 only accepts traffic from the ALB.
- **Lab:** [Go to Day-036](./Day-036)
- **Thoughts:** This lab reinforces the "Security Group Chaining" concept. The EC2 instance is effectively hidden from the public internet, accessible only through the "front door" (the ALB).

---

### 🗓️ Day 37: IAM Roles for EC2

**Date:** Feb 06, 2026

- **Activity:** Created a private S3 bucket and an IAM role (`nautilus-role`) to allow an EC2 instance to securely interact with S3 without using static credentials.
- **Lab:** [Go to Day-037](./Day-037)
- **Thoughts:** This is Cloud Security 101. Never use IAM User keys on an EC2 instance; always use Roles. It's cleaner, safer, and follows AWS best practices.

---

### 🗓️ Day 38: Amazon ECS & Fargate

**Date:** Feb 07, 2026

- **Activity:** Deployed a Python app via ECS. Configured the **Launch Type as Fargate** for a serverless compute experience, bypassing EC2 management.
- **Lab:** [Go to Day-038](./Day-038)
- **Thoughts:** Selecting the Launch Type is the fork in the road. By choosing Fargate, we traded infrastructure control for operational simplicity and "pay-as-you-go" compute.

---

### 🗓️ Day 39: Hosting a Static Website on AWS S3

**Date:** Feb 08, 2026

- **Activity:** Configured an S3 bucket (`nautilus-web-23944`) for static hosting. Documented the transition through 403 Forbidden and 404 Not Found errors to reach a successful 200 OK state.
- **Lab:** [Go to Day-039](./Day-039)
- **Thoughts:** Troubleshooting S3 access is easier when you understand that 403 means "Check Permissions" and 404 means "Check Objects."

---

### 🗓️ Day 40: VPC Troubleshooting (Visual Audit)

**Date:** Feb 09, 2026

- **Activity:** Used the VPC Resource Map to diagnose a detached Internet Gateway (`datacenter-ig`). Re-attached the IGW to restore internet flow to `datacenter-ec2`.
- **Lab:** [Go to Day-040](./Day-040)
- **Thoughts:** The VPC Resource Map is a life-saver for quick audits. It instantly highlighted the "gap" between our VPC and the internet, saving time on manual route table checks.

---

### 🗓️ Day 41: Data Security with AWS KMS

**Date:** Feb 10, 2026

- **Activity:** Created a symmetric KMS key (`datacenter-KMS-Key`) and utilized the AWS CLI to encrypt/decrypt local sensitive files using Base64 encoding.
- **Lab:** [Go to Day-041](./Day-041)
- **Thoughts:** KMS simplifies the complex math of encryption into a simple API call. The key takeaway is using `fileb://` in the CLI to ensure binary data is handled correctly during the process.

---

### 🗓️ Day 42: Amazon DynamoDB

**Date:** Feb 11, 2026

- **Activity:** Provisioned a DynamoDB table (`xfusion-tasks`) and performed manual item insertion to manage task data for a serverless application.
- **Lab:** [Go to Day-042](./Day-042)
- **Thoughts:** DynamoDB's simplicity is its strength. There’s no connection string to manage or server to patch; you just create the table and start writing data.

---

### 🗓️ Day 43: Amazon EKS Cluster Setup

**Date:** Feb 12, 2026

- **Activity:** Provisioned a private Amazon EKS cluster (`datacenter-eks`) using the latest Kubernetes version across three Availability Zones.
- **Lab:** [Go to Day-043](./Day-043)
- **Thoughts:** Configuring the cluster endpoint as Private is a major security win. It forces all administrative traffic through secure internal channels, which is a standard requirement for enterprise-grade infrastructure.

---

### 🗓️ Day 44: Auto Scaling & Load Balancing (AL2023)

**Date:** Feb 13, 2026

- **Activity:** Created a self-healing architecture using an ALB (`xfusion-alb`) and ASG (`xfusion-asg`). Troubleshot the resource dependency by creating Security Groups prior to the Launch Template.
- **Lab:** [Go to Day-044](./Day-044)
- **Thoughts:** Ordering matters in AWS. Creating the security groups first is a small but vital step that prevents "circular dependency" errors when building out automated infrastructure.

---

### 🗓️ Day 45: NAT Gateway Implementation

**Date:** Feb 14, 2026

- **Activity:** Enabled outbound internet access for a private EC2 instance by deploying a NAT Gateway (`datacenter-natgw`) in a newly created public subnet.
- **Lab:** [Go to Day-045](./Day-045)
- **Thoughts:** This is the standard "Safe" architecture. Keep your servers in private subnets and use a NAT Gateway for outbound needs. It provides security without sacrificing functionality.

---

### 🗓️ Day 46: S3 Event Triggers & Lambda

**Date:** Feb 15, 2026

- **Activity:** Automated file transfers between S3 buckets using a Lambda trigger and logged metadata to DynamoDB.
- **Lab:** [Go to Day-046](./Day-046)
- **Thoughts:** This is a classic serverless pattern. Using S3 events to trigger code means we only pay for the exact milliseconds it takes to move and log the file.

---

### 🗓️ Day 47: SNS and SQS Priority Messaging

**Date:** Feb 16, 2026

- **Activity:** Deployed a priority-based messaging system using CloudFormation. Successfully integrated SNS filtering with SQS and a Lambda consumer while managing complex IAM permissions via Managed Policies.
- **Lab:** [Go to Day-047](./Day-047)
- **Thoughts:** Troubleshooting CloudFormation stacks is 50% networking and 50% IAM. Using S3 to host function code is a more scalable approach than inline scripts for complex environments.

---

### 🗓️ Day 48: Lambda Deployment via CloudFormation

**Date:** Feb 17, 2026

- **Activity:** Automated the deployment of a serverless Python function (`devops-lambda`) and its execution role using a CloudFormation YAML template.
- **Lab:** [Go to Day-048](./Day-048)
- **Thoughts:** Using the `ZipFile` property in CloudFormation is a great way to handle "utility" scripts. It keeps the infrastructure and the logic in a single, readable file.

---

### 🗓️ Day 49: Centralized Audit Logging (VPC Peering)

**Date:** Feb 18, 2026

- **Activity:** Engineered a multi-VPC log aggregation system. Configured VPC Peering, Bastion Host access, and automated log transfers using `scp` and the AWS CLI.
- **Lab:** [Go to Day-049](./Day-049)
- **Thoughts:** Precision in routing and the proper installation of the AWS CLI toolchain are key to moving data between isolated environments and S3 effectively.

---

### 🗓️ Day 50: Dynamic EBS Volume Expansion

**Date:** Feb 19, 2026

- **Activity:** Performed a live storage expansion of the `xfusion-ec2` instance from 8 GiB to 12 GiB. Managed the partition and filesystem growth without instance downtime.
- **Lab:** [Go to Day-050](./Day-050)
- **Thoughts:** Halfway there! Dynamic scaling is a core cloud competency. Understanding the relationship between the block device, the partition, and the filesystem is vital for managing stateful applications.

### AZURE

---

### 🗓️ Day 51: SSH Key Pair Generation

**Date:** Feb 20, 2026

- **Activity:** Kicked off the Azure migration phase by generating a managed RSA SSH key pair (`devops-kp`) for secure VM access.
- **Lab:** [Go to Day-051](./Day-051)
- **Thoughts:** New cloud, new challenges. Starting with managed keys establishes a strong security baseline for the next 50 days of the journey.

---

### 🗓️ Day 52: Virtual Machine Deployment

**Date:** Feb 21, 2026

- **Activity:** Provisioned an Ubuntu 24.04 VM (`devops-vm`) in Central US. Configured custom Standard HDD storage and NSG rules for SSH access.
- **Lab:** [Go to Day-052](./Day-052)
- **Thoughts:** Moving from AWS EC2 to Azure VM feels familiar, but the resource grouping and NSG attachment flow are different. The B-series is a great entry point for this migration.

---

### 🗓️ Day 53: CLI-Based VM Provisioning

**Date:** Feb 22, 2026

- **Activity:** Automated the deployment of `datacenter-vm` using the Azure CLI. Configured Standard_LRS storage and 30GB disk sizing.
- **Lab:** [Go to Day-053](./Day-053)
- **Thoughts:** Moving away from the portal is a major milestone. Mastering the `az` command suite is what separates a cloud user from a Cloud Engineer.

---

### 🗓️ Day 54: Virtual Network Foundation

**Date:** Feb 23, 2026

- **Activity:** Provisioned the primary Virtual Network (`nautilus-vnet`) in Central US to serve as the backbone for the migrated infrastructure.
- **Lab:** [Go to Day-054](./Day-054)
- **Thoughts:** Networking is the foundation of any cloud migration. Establishing a clean, well-defined CIDR block today prevents routing headaches tomorrow.

---

### 🗓️ Day 55: Regional VNet Expansion

**Date:** Feb 24, 2026

- **Activity:** Provisioned `xfusion-vnet` in the East US region with a specialized `192.168.0.0/24` IPv4 address space.
- **Lab:** [Go to Day-055](./Day-055)
- **Thoughts:** Incremental migration often requires different IP strategies for different services. Moving to the 192.168.x.x range allows us to separate management traffic from application traffic.

---

### 🗓️ Day 56: Subnet Segmentation

**Date:** Feb 25, 2026

- **Activity:** Provisioned the `xfusion-vnet` (`10.0.0.0/16`) and created its first functional segment, `xfusion-subnet` (`10.0.0.0/24`), in Central US.
- **Lab:** [Go to Day-056](./Day-056)
- **Thoughts:** A VNet without a subnet is like a house without a rooms. Today, we laid the foundation for our first Azure-hosted applications.

---

### 🗓️ Day 57: Public IP Allocation

**Date:** Feb 26, 2026

- **Activity:** Provisioned a static Public IP address (`nautilus-pip`) in Central US via the Azure Portal.
- **Lab:** [Go to Day-057](./Day-057)
- **Thoughts:** An IP address is the "front door" of our cloud infrastructure. Allocating a static Public IP today ensures we have a consistent endpoint for future VM connectivity and management.

---

### 🗓️ Day 58: Managed Disk Attachment

**Date:** Feb 27, 2026

- **Activity:** Used the Azure CLI to hot-attach `nautilus-disk` to `nautilus-vm` in the East US region.
- **Lab:** [Go to Day-058](./Day-058)
- **Thoughts:** Storage management is about flexibility. Attaching a data disk separately from the OS disk is a best practice for managing large application datasets.

---

### 🗓️ Day 59: Multi-NIC Configuration

**Date:** Feb 28, 2026

- **Activity:** Successfully attached `xfusion-nic` to `xfusion-vm` via the Azure CLI. Resolved attachment constraints by deallocating the VM before reconfiguration.
- **Lab:** [Go to Day-059](./Day-059)
- **Thoughts:** The lab provided a great lesson in state management. You can't always modify hardware on the fly; sometimes you have to power down to scale up.

---

### 🗓️ Day 60: Public IP Association

**Date:** Mar 01, 2026

- **Activity:** Associated the `devops-pip` resource with the `devops-vm-pip` network interface using the Azure CLI.
- **Lab:** [Go to Day-060](./Day-060)
- **Thoughts:** This marks the completion of the basic connectivity phase. The VM is now reachable, and we've successfully navigated the 10-day Azure introduction.

---

### 🗓️ Day 61: Vertical Scaling & Optimization

**Date:** Mar 02, 2026

- **Activity:** Resized `datacenter-vm` from `Standard_B1s` to `Standard_B2s` via the Azure Portal to optimize resource usage.
- **Lab:** [Go to Day-061](./Day-061)
- **Thoughts:** Vertical scaling is one of the quickest ways to handle performance bottlenecks. It’s a reminder that cloud infrastructure is elastic—you aren't locked into your initial hardware choices.

---

### 🗓️ Day 62: Resource Tagging & Governance

**Date:** Mar 03, 2026

- **Activity:** Applied organizational metadata (`Environment=dev`) to the `devops-vm` to improve resource tracking and cost allocation.
- **Lab:** [Go to Day-062](./Day-062)
- **Thoughts:** Tagging might seem like a small task, but it's the foundation of a "well-architected" cloud. If you can't label it, you can't manage it.

---

### 🗓️ Day 63: Secure SSH Automation

**Date:** Mar 04, 2026

- **Activity:** Configured passwordless SSH access for the `root` user on `nautilus-vm`. Managed NSG port opening and key injection via CLI and SCP.
- **Lab:** [Go to Day-063](./Day-063)
- **Thoughts:** This was a great exercise in Linux permission management and Azure networking. Setting the `PermitRootLogin` correctly is a small but vital step for management automation.

---

### 🗓️ Day 64: Managed Disk Provisioning

**Date:** Mar 05, 2026

- **Activity:** Provisioned a 2 GiB managed disk (`xfusion-disk`) with Standard_LRS redundancy in the East US region using the Azure Portal.
- **Lab:** [Go to Day-064](./Day-064)
- **Thoughts:** Even small resources require proper configuration. Using the portal today allowed me to visualize the different redundancy tiers and performance SKUs available for managed storage.

---

### 🗓️ Day 65: Network Security Hardening

**Date:** Mar 07, 2026

- **Activity:** Provisioned `devops-nsg` and configured inbound rules for HTTP (80) and SSH (22) traffic via the Azure Portal.
- **Lab:** [Go to Day-065](./Day-065)
- **Thoughts:** The NSG is our first line of defense. Understanding how to wrap these rules around our subnets and VMs is the key to a "Zero Trust" architecture in Azure.
