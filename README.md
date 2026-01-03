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