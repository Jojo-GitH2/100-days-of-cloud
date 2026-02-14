# Day 45: Configure NAT Gateway for Internet Access in a Private VPC

## Project Description

Today's task for the Nautilus DevOps team was to establish secure outbound internet connectivity for resources in a private network. I implemented a **NAT Gateway** architecture within `datacenter-priv-vpc` to allow a private EC2 instance (`datacenter-priv-ec2`) to communicate with the internet without being exposed to inbound threats.

![alt text](./assets/image.png)

**The Goal:**
Enable a private instance to perform an automated file upload to an S3 bucket (`datacenter-nat-23173`) by providing a controlled outbound path through a public subnet.

## Steps & Configuration

### Step 1: Establish Public Infrastructure

_Since the VPC was purely private, I had to create a "Front Door" for outbound traffic._

1. **Create Public Subnet:** Created `datacenter-pub-subnet` in the `datacenter-priv-vpc`.
   ![alt text](./assets/image-1.png)
   ![alt text](./assets/image-2.png)
   ![alt text](./assets/image-3.png)

2. **Internet Gateway (IGW):**
   _Created an IGW.
   _ Attached it to `datacenter-priv-vpc`.
   ![alt text](./assets/image-4.png)
   ![alt text](./assets/image-5.png)
   ![alt text](./assets/image-6.png)
   ![alt text](./assets/image-7.png)

3. **Public Route Table:**
   _Created `datacenter-pub-rt`.
   _ Added route: `0.0.0.0/0` -> **Internet Gateway**. \* Associated this route table with `datacenter-pub-subnet`.
   ![alt text](./assets/image-8.png)
   ![alt text](./assets/image-9.png)
   ![alt text](./assets/image-10.png)
   ![alt text](./assets/image-11.png)
   ![alt text](./assets/image-12.png)
   ![alt text](./assets/image-13.png)

### Step 2: Deploy the NAT Gateway

1. **Allocate Elastic IP:** Navigated to **EC2** > **Elastic IPs** and allocated a new EIP.
   ![alt text](./assets/image-14.png)

2. **Create NAT Gateway:**
   _**Name:** `datacenter-natgw`.
   _ **Subnet:** Selected the **Public Subnet** (`datacenter-pub-subnet`).
   _**Connectivity Type:** Public.
   _ **Elastic IP Allocation ID:** Selected the EIP created above.
   ![alt text](./assets/image-17.png)
   ![alt text](./assets/image-18.png)

### Step 3: Configure Private Routing

_This is the critical step that "plugs" the private subnet into the internet._

1. Navigate to **VPC** > **Route Tables**.
2. Selected the route table associated with `datacenter-priv-subnet`.
3. **Edit Routes:**
   - **Destination:** `0.0.0.0/0`.
   - **Target:** **NAT Gateway** > selected `datacenter-natgw`.
     ![alt text](./assets/image-19.png)
4. Saved changes.

### Step 4: Verification

1. The instance `datacenter-priv-ec2` has a pre-configured cron job to upload a file to S3 once internet access is detected.
2. **Wait:** Allowed 3 minutes for the NAT Gateway to initialize and the cron job to trigger.
3. **Validation:** Navigated to the **S3 Console** > `datacenter-nat-23173`.
4. **Result:** Confirmed the presence of the test file, verifying successful outbound connectivity.
   ![alt text](./assets/image-20.png)
   ![alt text](./assets/image-21.png)

## 🧠 Theory: NAT Gateway vs. Internet Gateway

Today's lab highlights the fundamental difference between public and private cloud networking:

- **Internet Gateway (IGW):** A horizontally scaled, redundant VPC component that allows communication between your VPC and the internet. It supports **One-to-One NAT**, meaning it allows both inbound and outbound traffic. This is why it is only attached to Public Subnets.
- **NAT Gateway (Network Address Translation):** A managed service used to allow instances in a **Private Subnet** to connect to services outside the VPC, but prevents the internet from initiating a connection with those instances.
- **The Flow:** The private instance sends a request to the NAT Gateway (via the private route table). The NAT Gateway replaces the instance's private IP with its own **Elastic IP** and forwards the request to the IGW (via the public route table). This ensures the instance remains "hidden" from the public web while still being able to download patches or upload data to S3.

![alt text](./assets/image-22.png)
