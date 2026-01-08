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