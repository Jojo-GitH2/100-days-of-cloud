# Day 21: Setting Up an EC2 Instance with an Elastic IP

## Project Description

Today's task for the Nautilus DevOps team was a full provisioning workflow. The Development Team required a new environment to host an application, with the strict requirement that the entry point (IP address) must not change, even if the server is restarted.

To achieve this, I launched a new Linux EC2 instance (`devops-ec2`) and immediately associated it with a static Elastic IP (`devops-eip`).



## Steps & Configuration

### Method: Using AWS Management Console

#### Part 1: Launch the Instance
1. **Log in:** Access the [AWS Management Console](https://aws.amazon.com/console/) and navigate to the **EC2 Dashboard**.
2. **Launch Instance:**
   - Click **Launch instance**.
   - **Name:** `devops-ec2` (Strict requirement).
   - **AMI:** Ubuntu Server 24.04 LTS (or any free-tier Linux AMI).
   - **Instance Type:** `t2.micro` (Strict requirement).
   - **Key Pair:** Select an existing key pair (e.g., `devops-kp`).
   - **Network:** Default VPC and Subnet.
   - Click **Launch instance**.

#### Part 2: Allocate Elastic IP
1. **Navigate to Elastic IPs:**
   - In the left sidebar under **Network & Security**, click **Elastic IPs**.
   - Click **Allocate Elastic IP address**.
2. **Configure:**
   - **Region:** `us-east-1` (Match your instance region).
   - **Tags:**
     - Key: `Name`
     - Value: `devops-eip` (Strict requirement).
   - Click **Allocate**.

#### Part 3: Associate Elastic IP
1. **Associate:**
   - Select the newly created Elastic IP (`devops-eip`).
   - Click **Actions** > **Associate Elastic IP address**.
2. **Link to Instance:**
   - **Resource type:** Instance.
   - **Instance:** Select `devops-ec2` from the list.
   - Click **Associate**.

#### Verification
1. Go to the **Instances** dashboard.
2. Select `devops-ec2`.
3. Check the **Public IPv4 address** field. It should match the Elastic IP address, and the text should be blue (indicating it is a link to the EIP).

## 🧠 Theory: Dynamic vs. Static IPs
By default, EC2 public IPs are **Dynamic**. If the Dev team stops the instance to resize it or perform maintenance, the IP changes when it boots back up. This breaks DNS records and configuration files.

By attaching an **Elastic IP**, we make the endpoint **Static**, providing a reliable contract for the Development Team.

![alt text](image.png)

![alt text](image-1.png)

![alt text](image-2.png)

![alt text](image-3.png)

![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-6.png)

![alt text](image-7.png)

![alt text](image-8.png)

![alt text](image-9.png)


![alt text](image-11.png)

![alt text](image-12.png)

![alt text](image-13.png)

![alt text](image-14.png)

![alt text](image-15.png)