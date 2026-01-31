# Day 29: VPC Peering (Connecting Isolated Networks)

## Project Description

Today's task for the Nautilus DevOps team was to bridge two isolated networks.
We needed to establish a secure communication line between a **Public EC2 instance** (in the Default VPC) and a **Private EC2 instance** (in a custom Private VPC) without using the public internet.

![alt text](./assets/image.png)

**The Solution: VPC Peering.**

VPC Peering allows two VPCs to communicate with each other as if they are in the same network. Traffic stays entirely within the AWS global infrastructure.

## Steps & Configuration

### Part 1: Create Peering Connection

1.  **Navigate:** Go to **VPC Dashboard** > **Peering connections** > **Create peering connection**.
    ![alt text](./assets/image-1.png)
    ![alt text](./assets/image-2.png)
    ![alt text](./assets/image-3.png)

2.  **Configure:**
    - **Name:** `devops-vpc-peering` (Strict requirement).
    - **VPC (Requester):** Select the **Default VPC** (containing `devops-public-ec2`).
    - **VPC (Accepter):** Select `devops-private-vpc`.
      ![alt text](./assets/image-4.png)
      ![alt text](./assets/image-5.png)
      ![alt text](./assets/image-6.png)

3.  **Create:** Click **Create peering connection**.

4.  **Accept:**
    - Select the connection > **Actions** > **Accept request**.
      ![alt text](./assets/image-7.png)
      ![alt text](./assets/image-8.png)
      ![alt text](./assets/image-9.png)

### Part 2: Update Route Tables (The Bridge)

A peering connection exists, but no traffic knows how to use it yet. We must update the "maps" (Route Tables) on both sides.

1.  **Public (Default) VPC Route Table:** - **Destination:** `10.1.0.0/16` (Private VPC CIDR). - **Target:** `Peering Connection` > `devops-vpc-peering`.
    ![alt text](./assets/image-10.png)
    ![alt text](./assets/image-11.png)
    ![alt text](./assets/image-12.png)
    ![alt text](./assets/image-13.png)

2.  **Private VPC Route Table:**
    - **Destination:** `172.31.0.0/16` (Default VPC CIDR).
    - **Target:** `Peering Connection` > `devops-vpc-peering`.
      ![alt text](./assets/image-14.png)

### Part 3: Security Group Configurations

Firewalls block traffic by default. We need to open the doors on both instances.

1.  **Public EC2 Security Group (`devops-public-ec2`):** - **Inbound Rule:** Allow **SSH (Port 22)**. - **Why?** To allow us to use **EC2 Instance Connect** to log in and configure the keys.
    ![alt text](./assets/image-15.png)
    ![alt text](./assets/image-16.png)

2.  **Private EC2 Security Group (`devops-private-ec2`):** - **Inbound Rule:** Allow **All ICMP - IPv4** (Ping). - **Source:** `172.31.0.0/16` (The Public VPC CIDR). - **Why?** To allow the Public EC2 to ping the Private EC2 through the peering connection.
    ![alt text](./assets/image-17.png)
    ![alt text](./assets/image-18.png)

### Part 4: Access & Verification

Since the instances already existed, I couldn't use User Data to inject my SSH key. I used a workaround:

1.  **Inject Keys via Instance Connect:** - On the `aws-client`, I copied the public key: `cat /root/.ssh/id_rsa.pub`. - I went to the AWS Console > EC2 > Selected `devops-public-ec2` > **Connect** > **EC2 Instance Connect**.
    ![alt text](./assets/image-19.png)
    ![alt text](./assets/image-20.png)
    ![alt text](./assets/image-21.png)
    ![alt text](./assets/image-22.png)

        - Once logged in via the browser, I added the key manually:
          ```bash
          nano ~/.ssh/authorized_keys
          ```

    ![alt text](./assets/image-23.png)

        - _Now the `aws-client` (KodeKloud terminal) is authorized to SSH in._

2.  **Test Connectivity:**
    - SSH from `aws-client` to Public EC2:

      ```bash
      ssh ec2-user@<PUBLIC-IP-OF-DEVOPS-PUBLIC-EC2>
      ```

      ![alt text](./assets/image-25.png)

    - From inside the Public EC2, ping the Private EC2's internal IP:

      ```bash
      ping <PRIVATE-IP-OF-DEVOPS-PRIVATE-EC2>
      ```

      ![alt text](./assets/image-26.png)
      ![alt text](./assets/image-27.png)

    - **Success:** You should see successful packet replies.

## 🧠 Theory: Peering is Non-Transitive

VPC Peering has a "Star" topology, not a "Mesh."
If VPC A peers with VPC B, and VPC B peers with VPC C... **VPC A cannot talk to VPC C.**
You would need a direct peering connection between A and C.

![alt text](./assets/image-28.png)
