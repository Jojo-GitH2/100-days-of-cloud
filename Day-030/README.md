# Day 30: Enable Internet Access via NAT Instance

## Project Description

Today's task for the Nautilus DevOps team was to solve a classic networking problem: **Cost Optimization**.
We needed to give a private EC2 instance (`devops-priv-ec2`) access to the internet so it could upload backup files to an S3 bucket (`devops-nat-24168`).

![alt text](./assets/image.png)

**The Constraint:**
Instead of using the AWS Managed **NAT Gateway** (which costs ~$0.045/hr + data processing fees), I built a custom **NAT Instance** using a standard EC2 machine.

## Steps & Configuration

### Step 1: Network Foundation (IGW & Public Subnet)

Before launching the NAT instance, I had to ensure the VPC actually had a path to the internet.

1.  **Create Internet Gateway:**
    _ Created a new Internet Gateway named `igw-devops`.
    _ Attached it to the VPC `devops-priv-vpc`.
    ![alt text](./assets/image-3.png)
    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-5.png)
    ![alt text](./assets/image-6.png)
    ![alt text](./assets/image-7.png)

2.  **Create Public Subnet:** \* Created `devops-pub-subnet` inside `devops-priv-vpc`.
    ![alt text](./assets/image-1.png)
    ![alt text](./assets/image-2.png)

3.  **Configure Routing (The "Public" Status):** - Located the **Main Route Table** associated with the VPC. - Added a route: - **Destination:** `0.0.0.0/0` - **Target:** `igw-devops` - Ensured `devops-pub-subnet` was associated with this route table.
    ![alt text](./assets/image-8.png)
    ![alt text](./assets/image-9.png)
    ![alt text](./assets/image-10.png)

### Step 2: Launch NAT Instance

1.  Navigate to **EC2** > **Launch Instance**. - **Name:** `devops-nat-instance`. - **AMI:** Amazon Linux 2. - **Network:** `devops-priv-vpc`. - **Subnet:** `devops-pub-subnet`. - **Auto-assign Public IP:** Enable.
    ![alt text](./assets/image-11.png)
    ![alt text](./assets/image-12.png)
    ![alt text](./assets/image-13.png)

2.  **Security Group:**
    - Create a new Security Group.
    - **Inbound Rules:** Allow **All Traffic** from the **Private Subnet CIDR**.
      ![alt text](./assets/image-14.png)

3.  **User Data (Configure IP Masquerading):**
    - I used this specific bash script to update `iptables` and route traffic through the `ens5` interface:
    ```bash
    #!/bin/bash -x
    yum update -y
    yum install -y iptables iproute
    echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
    sysctl -p
    iptables -t nat -A POSTROUTING -o ens5 -s 0.0.0.0/0 -j MASQUERADE
    yum install iptables-services -y
    service iptables save
    ```
    ![alt text](./assets/image-15.png)

### Step 3: Disable Source/Destination Check

_This is the most critical step for NAT Instances._

1.  Select `devops-nat-instance` in the EC2 console.
2.  Click **Actions** > **Networking** > **Change source/destination check**.
3.  Check the box for **Stop** (Disable).
4.  Click **Save**.
    > _Why?_ EC2 default security blocks traffic not destined for the instance itself. Since a NAT routes traffic for others, this check must be disabled.

![alt text](./assets/image-16.png)
![alt text](./assets/image-17.png)

### Step 4: Update Private Route Table

1.  Navigate to **VPC** > **Route Tables**.
2.  Find the Route Table associated with the **Private Subnet** (`devops-priv-subnet`).
3.  Click **Edit routes**.
    - **Destination:** `0.0.0.0/0` (The Internet).
    - **Target:** Select **Instance**, then choose `devops-nat-instance`.
4.  Click **Save changes**.
    ![alt text](./assets/image-18.png)
    ![alt text](./assets/image-19.png)
    ![alt text](./assets/image-20.png)

### Step 5: Verification

1.  Wait a few minutes for the cron job on the private instance to run.
2.  Navigate to **S3** and open bucket `devops-nat-24168`.
3.  Verify that `devops-test.txt` has appeared. 
    - _Success:_ The private instance routed traffic -> NAT Instance -> IGW (`igw-devops`) -> S3.
    ![alt text](./assets/image-21.png)
    ![alt text](./assets/image-22.png)

## 🧠 Theory: NAT Gateway vs. NAT Instance

- **NAT Gateway:** Fully managed, highly available, scales automatically. Expensive ($$$).
- **NAT Instance:** You manage it (patching, scaling). If it crashes, internet stops. Cheap (Can be Free Tier).

![alt text](./assets/image-23.png)
