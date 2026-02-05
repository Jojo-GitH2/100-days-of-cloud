# Day 36: Load Balancing EC2 Instances (ALB)

## Project Description

Today's task for the Nautilus DevOps team was to improve application availability by introducing an **Application Load Balancer (ALB)**.
Instead of exposing the web server directly to the internet, I placed it behind an ALB (`xfusion-alb`). This setup allows for better traffic distribution and security.

![alt text](./assets/image.png)

**The Architecture:**

- **ALB:** Receives public traffic on Port 80.
- **EC2:** Runs Nginx, accessible ONLY via the ALB.
- **Security:** Traffic is filtered using Security Group referencing.

## Steps & Configuration

### Part 1: Security Group Setup

_The strategy: The ALB talks to the world; the EC2 only talks to the ALB._

1.  **Configure ALB Security Group (`default`):**
    - I located the `default` Security Group.
    - **Inbound Rule:** Added HTTP (80) from `0.0.0.0/0` (Anywhere).
    - _Why? The Load Balancer needs to accept traffic from the internet._
      ![alt text](./assets/image-19.png)
      ![alt text](./assets/image-20.png)

2.  **Create EC2 Security Group (`xfusion-sg`):**
    - Created a new group named `xfusion-sg`.
    - **Inbound Rule:** Added HTTP (80).
    - **Source:** Custom > Selected the **Group ID** of the `default` security group.
    - _Why? This ensures the EC2 instance rejects any traffic that didn't pass through the Load Balancer._
      ![alt text](./assets/image-1.png)
      ![alt text](./assets/image-2.png)

### Part 2: Launch EC2 Instance

1.  **Launch Instance:**
    - **Name:** `xfusion-ec2`.
    - **AMI:** Ubuntu.
    - **Security Group:** Attached `xfusion-sg`.
2.  **User Data (Auto-Install Nginx):**
    - I used this script to configure the web server on boot:
    ```bash
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```
    ![alt text](./assets/image-3.png)
    ![alt text](./assets/image-5.png)
    ![alt text](./assets/image-4.png)

### Part 3: Create Target Group

1.  Navigate to **EC2** > **Target Groups**.
2.  **Create target group:**
    - **Name:** `xfusion-tg`.
    - **Target type:** Instances.
    - **Protocol:** HTTP (80).
    - **Register Targets:** Selected `xfusion-ec2` and clicked "Include as pending below".
      ![alt text](./assets/image-11.png)
      ![alt text](./assets/image-12.png)
      ![alt text](./assets/image-13.png)
      ![alt text](./assets/image-14.png)
      ![alt text](./assets/image-15.png)

### Part 4: Create Application Load Balancer

1.  Navigate to **EC2** > **Load Balancers**.
2.  **Create Load Balancer:** Application Load Balancer (ALB).
3.  **Name:** `xfusion-alb`.
4.  **Network Mapping:** Selected the VPC and at least two subnets (ALBs require at least two AZs).
5.  **Security Groups:** Selected `default` (as configured in Part 1).
6.  **Listeners:**
    - Protocol: HTTP (80).
    - Default Action: Forward to `xfusion-tg`.
      ![alt text](./assets/image-6.png)
      ![alt text](./assets/image-7.png)
      ![alt text](./assets/image-8.png)
      ![alt text](./assets/image-9.png)
      ![alt text](./assets/image-10.png)
      ![alt text](./assets/image-16.png)
      ![alt text](./assets/image-17.png)
      ![alt text](./assets/image-18.png)

### Part 5: Verification

1.  I copied the **DNS Name** of the ALB (e.g., `xfusion-alb-1234.us-east-1.elb.amazonaws.com`).
2.  Pasted it into the browser.
3.  **Success:** The "Welcome to nginx!" default page loaded. - _Note: If I try to access the EC2 IP directly, it times out (because `xfusion-sg` only allows traffic from the ALB)._
    ![alt text](./assets/image-22.png)

## 🧠 Theory: Why use an ALB for a single instance?

It seems redundant for one server, right? But it provides:

1.  **Decoupling:** You can replace the underlying EC2 instance (e.g., for patching) without changing the DNS name users type.
2.  **SSL Termination:** You can handle HTTPS certificates on the ALB, offloading CPU work from the application server.
3.  **WAF Integration:** You can attach AWS WAF to the ALB to block attacks before they reach your server.
    ![alt text](./assets/image-21.png)
