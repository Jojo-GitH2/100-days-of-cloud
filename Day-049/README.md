# Day 49: Centralized Audit Logging with VPC Peering

## Project Description

The Nautilus DevOps team required a secure, cross-VPC architecture to aggregate logs from isolated environments. I implemented a **VPC Peering** connection between a private application VPC (`devops-priv-vpc`) and a public management VPC (`devops-pub-vpc`). This architecture enables a multi-stage log pipeline where sensitive data is transferred via private IP space before being archived to a hardened, private S3 bucket.

![alt text](./assets/image.png)

**Technical Objectives:**

- Establish non-overlapping VPC CIDR routing via Peering.
- Implement a **Bastion Host (Jump Server)** access pattern for private instance management.
- Automate secure log rotation and transfer using the **AWS CLI**.

## Technical Specifications

| Component       | Specification                       |
| :-------------- | :---------------------------------- |
| **Private VPC** | `devops-priv-vpc` (10.0.0.0/16)     |
| **Public VPC**  | `devops-pub-vpc` (10.10.0.0/16)     |
| **Peering ID**  | `devops-vpc-peering`                |
| **S3 Bucket**   | `devops-s3-logs-9105` (Private)     |
| **Aggregator**  | `devops-pub-ec2` (Ubuntu + AWS CLI) |

---

## Steps & Configuration

### 1. Infrastructure Provisioning

1. **VPC & Subnet:** Created `devops-pub-vpc` and `devops-pub-subnet`.
   ![alt text](./assets/image-1.png)

2. **Internet Access:** Attached an **Internet Gateway (IGW)** and configured `devops-pub-rt` with a default route `0.0.0.0/0 -> IGW`.
   ![alt text](./assets/image-2.png)

3. **Public Instance:** Launched `devops-pub-ec2` with **Auto-assign public IPv4** enabled.
   ![alt text](./assets/image-3.png)
   ![alt text](./assets/image-4.png)
   ![alt text](./assets/image-5.png)

### 2. IAM & S3 Configuration

1. **S3 Bucket:** Created the private bucket `devops-s3-logs-9105`.
   ![alt text](./assets/image-6.png)
   ![alt text](./assets/image-30.png)

2. **IAM Policy:** Created a policy allowing `s3:PutObject` on `arn:aws:s3:::devops-s3-logs-9105/*`.
   ![alt text](./assets/image-7.png)
   ![alt text](./assets/image-8.png)
   ![alt text](./assets/image-9.png)
   ![alt text](./assets/image-10.png)

3. **IAM Role:** Created `devops-s3-role`, attached the policy, and associated the role with `devops-pub-ec2`.

### 3. VPC Peering & Routing

1. **Connection:** Established `devops-vpc-peering` between the two VPCs.
   ![alt text](./assets/image-11.png)
   ![alt text](./assets/image-12.png)
   ![alt text](./assets/image-13.png)
   ![alt text](./assets/image-14.png)

2. **Routing Tables:**
   - **`devops-priv-rt`:** Added route `10.10.0.0/16` -> Peering ID.
   - **`devops-pub-rt`:** Added route `10.0.0.0/16` -> Peering ID.
     ![alt text](./assets/image-15.png)
     ![alt text](./assets/image-16.png)
     ![alt text](./assets/image-17.png)
     ![alt text](./assets/image-18.png)
     ![alt text](./assets/image-19.png)
     ![alt text](./assets/image-20.png)

### 4. Access & Tooling Setup

1. **Copy the private key to the public instance:**

   ```bash
   scp -i /root/.ssh/devops-key.pem /root/.ssh/devops-key.pem ubuntu@<PUBLIC_INSTANCE_PUBLIC_IP>:/home/ubuntu/
   ```

   ![alt text](./assets/image-21.png)

2. **SSH into `devops-pub-ec2` from `aws-client` host using its public IP:**

   ```bash
   ssh -i .ssh/devops-key.pem ubuntu@<devops-pub-ec2-public-ip>
   ```

   ![alt text](./assets/image-22.png)

3. **"Jump" to the Private Instance:**
   Once inside the public instance, set the correct permissions for the key and SSH into the private instance using its Private IP:

   ```bash
   # Set secure permissions for the key
   chmod 400 /home/ubuntu/devops-key.pem

   # Copy private key from public to private instance
   scp -i /home/ubuntu/devops-key.pem /home/ubuntu/devops-key.pem ubuntu@<PRIVATE_INSTANCE_PRIVATE_IP>:/home/ubuntu/

   # SSH into the private instance
   ssh -i /home/ubuntu/devops-key.pem ubuntu@<PRIVATE_INSTANCE_PRIVATE_IP>
   ```

   ![alt text](./assets/image-32.png)
   ![alt text](./assets/image-23.png)

4. **Open Crontab on the Private Instance:**

   ```bash
   crontab -e
   ```

   ![alt text](./assets/image-24.png)

---

### 5. Log Pipeline Automation (Cron Jobs)

#### Stage A: Private to Public (Internal)

On `devops-priv-ec2`, a cron job moves the log file across the peering link every minute:

```bash
* * * * * scp /var/log/boots.log ubuntu@10.20.1.53:~/boot/boots.log
```

#### Stage B: Public to S3

**First, install the AWS CLI on the public aggregator:**

```bash
sudo apt install unzip
curl "[https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip)" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
```

**Configure AWS Credentials:**

```bash
aws configure

# Enter Access Key, Secret Key, Region (us-east-1), and Output (json)
```

**Set cronjob in `devops-pub-ec2`:**

```bash
* * * * * aws s3 cp ~/boot/boots.log s3://devops-s3-logs-9105/devops-priv-vpc/boot/boots.log
```

### Verification

1. **Check Local Temporary Path:**
2. **Verify S3 Archival:**

## 🧠 Theory: VPC Peering and CLI Integration

- **VPC Peering Isolation:** Traffic remains within the AWS network backbone. By using the private IP for the `scp` transfer, we ensure the logs are never exposed to the public internet.

- **AWS CLI v2 Utility:** The CLI simplifies the S3 upload by handling multipart uploads and the Signature Version 4 signing process automatically, making the final archival step highly reliable.

- **Bastion Host Ingress:** The private instance remains secure by only allowing SSH ingress from the public subnet CIDR, enforcing a "single point of entry" for administrative tasks.

![alt text](./assets/image-34.png)
