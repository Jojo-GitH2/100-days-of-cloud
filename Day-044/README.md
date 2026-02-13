# Day 44: Implementing Auto Scaling for High Availability in AWS

## Project Description

Today's task for the Nautilus DevOps team was to build a self-healing, scalable web architecture. I implemented an **Application Load Balancer (ALB)** and an **Auto Scaling Group (ASG)** using **Amazon Linux 2023** to ensure our Nginx web servers can handle traffic spikes and recover automatically from instance failures.

![alt text](./assets/image.png)

**The Goal:**

Automate the lifecycle of EC2 instances using a modern AL2023 Launch Template and an ASG, while using an ALB as the single point of entry for web traffic.

## Steps & Configuration

### Step 1: Pre-requisite - Security Group Creation

_Since the Launch Template and ALB both require Security Groups, I created these first to avoid dependency issues._

1.  **ALB Security Group (`xfusion-alb-sg`):**
    - Inbound: Allow **HTTP (80)** from `0.0.0.0/0`.
      ![alt text](./assets/image-1.png)

2.  **EC2 Security Group (`xfusion-ec2-sg`):** - Inbound: Allow **HTTP (80)**. - **Source:** For now, set to `0.0.0.0/0` (In a production environment, I would later update this to only allow the `xfusion-alb-sg` ID once the ALB is live).
    ![alt text](./assets/image-2.png)
    ![alt text](./assets/image-3.png)

### Step 2: Create EC2 Launch Template

1.  Navigate to **EC2** > **Launch Templates** > **Create launch template**.
2.  **Name:** `xfusion-launch-template`.
3.  **AMI:** Amazon Linux 2023.
4.  **Instance Type:** `t2.micro`.
5.  **Security Group:** Selected `xfusion-ec2-sg`.
6.  **User Data (AL2023 Syntax):**
    `bash
#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl start nginx
systemctl enable nginx
`
    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-5.png)
    ![alt text](./assets/image-6.png)
    ![alt text](./assets/image-7.png)
    ![alt text](./assets/image-8.png)
    ![alt text](./assets/image-9.png)

### Step 3: Create Target Group and ALB

1.  **Target Group:** - Name: `xfusion-tg`. - Target Type: Instances | Protocol: HTTP (80).
    ![alt text](./assets/image-10.png)
    ![alt text](./assets/image-11.png)

2.  **Application Load Balancer:** - Name: `xfusion-alb`. - Security Group: Selected `xfusion-alb-sg`. - Listeners: Port 80 forwarding to `xfusion-tg`. - Subnets: Selected at least two public subnets.
    ![alt text](./assets/image-12.png)
    ![alt text](./assets/image-13.png)
    ![alt text](./assets/image-14.png)
    ![alt text](./assets/image-15.png)

### Step 4: Create Auto Scaling Group

1.  Navigate to **EC2** > **Auto Scaling Groups** > **Create**.
2.  **Name:** `xfusion-asg`.
3.  **Launch Template:** `xfusion-launch-template`.
4.  **Load Balancing:** Attached to `xfusion-tg`.
5.  **Group Size:** Desired: 1, Min: 1, Max: 2.
6.  **Scaling Policy:** Target Tracking (Average CPU Utilization at **50%**).
    ![alt text](./assets/image-16.png)
    ![alt text](./assets/image-17.png)
    ![alt text](./assets/image-18.png)
    ![alt text](./assets/image-19.png)
    ![alt text](./assets/image-20.png)
    ![alt text](./assets/image-21.png)

### Step 5: Verification

1.  Accessed the **ALB DNS Name** in a browser.
2.  **Result:** **200 OK**. The Nginx default page is served.
3.  Confirmed the ASG successfully launched the instance and the ALB marked it as "Healthy."
    ![alt text](./assets/image-22.png)

## 🧠 Theory: Decoupling Dependencies and Elasticity

The activities today highlight the importance of resource ordering and horizontal scaling:

- **Dependency Management:** By creating Security Groups first, we decouple the firewall rules from the physical resources. This allows the Launch Template to reference a security group before the instances or the Load Balancer even exist.
- **Target Tracking Scaling:** This policy acts as the "brain" of the ASG. By setting a 50% CPU threshold, we utilize a reactive scaling feedback loop. When the metric is exceeded, the ASG triggers a "Scale Out" event to maintain performance.
- **Modern Package Management (AL2023):** Using `dnf` in Amazon Linux 2023 provides a faster startup time for new instances compared to the older `yum` and `amazon-linux-extras` workflow, making our auto-scaling response more efficient.

![alt text](./assets/image-23.png)
