# 100 Days of Cloud Challenge

**Start Date:** January 1, 2026  
**End Date:** April 10, 2026  
**Status:** 🟢 Active  
**Author:** Jonah Uka | Cloud Administrator & .NET Developer

## 🚀 The Goal

I am documenting my journey from Cloud Administrator to Cloud Engineer. Over the next 100 days, I will deep-dive into Multi-Cloud architectures (AWS & Azure) following the [KodeKloud](https://kodekloud.com) Cloud Engineer Path.

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

### Day 11: Attach Elastic Network Interface (ENI)

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
