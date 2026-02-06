# Day 37: Managing EC2 Access with S3 Role-based Permissions

## Project Description

Today's task for the Nautilus DevOps team was to implement the **Principle of Least Privilege** using IAM Roles. Instead of hardcoding access keys into our application, we granted the `nautilus-ec2` instance temporary security credentials via an IAM Instance Profile.
![alt text](./assets/image.png)

**The Goal:**

Securely allow an EC2 instance to list, upload, and download files from a specific, private S3 bucket (`nautilus-s3-12964`).

## Steps & Configuration

### Step 1: Security Group Preparation

_Before accessing the instance, I had to ensure the virtual door was open._

1.  Navigate to **EC2** > **Security Groups**.
2.  Select the group attached to `nautilus-ec2`.
3.  **Inbound Rules:** Added **SSH (Port 22)** from `0.0.0.0/0` (or specific Instance Connect IP ranges) to allow access.
    ![alt text](./assets/image-5.png)
    ![alt text](./assets/image-7.png)
    ![alt text](./assets/image-6.png)

### Step 2: SSH Key & Root Access

1.  **On `aws-client` host:**

    ```bash
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
    cat /root/.ssh/id_rsa.pub
    ```

    ![alt text](./assets/image-1.png)

2.  **Authorize Key via Instance Connect:** \* Logged into `nautilus-ec2` via the browser console.
    ![alt text](./assets/image-2.png)
    ![alt text](./assets/image-3.png)
    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-8.png)
    - **Switch to root:** `sudo su -` (Required to modify root's directory).
    - Added the public key: `echo "ssh-rsa AAAAB3..." >> /root/.ssh/authorized_keys`.

    ![alt text](./assets/image-9.png)
    ![alt text](./assets/image-10.png)
    ![alt text](./assets/image-11.png)

### Step 3: Create Private S3 Bucket

1.  Navigate to **S3** > **Create bucket**.
2.  **Bucket name:** `nautilus-s3-12964`.
3.  **Public Access:** Ensured "Block all public access" is checked.
    ![alt text](./assets/image-12.png)
    ![alt text](./assets/image-13.png)
    ![alt text](./assets/image-14.png)
    ![alt text](./assets/image-15.png)

### Step 4: IAM Policy and Role

1.  **Create Policy:**
    - **Name:** `nautilus-s3-policy`.
    - **Permissions:** Allowed `s3:ListBucket`, `s3:PutObject`, and `s3:GetObject` for `nautilus-s3-12964`.
      ![alt text](./assets/image-16.png)
      ![alt text](./assets/image-17.png)
      ![alt text](./assets/image-18.png)
      ![alt text](./assets/image-20.png)
      ![alt text](./assets/image-21.png)
      ![alt text](./assets/image-22.png)
      ![alt text](./assets/image-23.png)

2.  **Create Role:**
    - **Name:** `nautilus-role`.
    - **Trusted Entity:** EC2.
    - **Attach Policy:** `nautilus-s3-policy`.
      ![alt text](./assets/image-24.png)
      ![alt text](./assets/image-25.png)
      ![alt text](./assets/image-26.png)
      ![alt text](./assets/image-27.png)
      ![alt text](./assets/image-28.png)

3.  **Attach to Instance:**
    - Selected `nautilus-ec2` > **Actions** > **Security** > **Modify IAM role** > Selected `nautilus-role`.
      ![alt text](./assets/image-29.png)
      ![alt text](./assets/image-30.png)

### Step 5: Verification

1.  SSH from `aws-client` into the instance: `ssh root@<EC2-IP>`.
    ![alt text](./assets/image-31.png)

2.  Create a dummy file: `echo "Nautilus Lab Test" > testfile.txt`.
    ![alt text](./assets/image-32.png)

3.  **Upload:** `aws s3 cp testfile.txt s3://nautilus-s3-12964/`
    ![alt text](./assets/image-33.png)

4.  **List:** `aws s3 ls s3://nautilus-s3-12964/`
    ![alt text](./assets/image-34.png)

![alt text](./assets/image-35.png)

## 🧠 Theory: Why Roles over Keys?

With **IAM Roles**, AWS rotates temporary credentials automatically. No static keys exist on the disk to be stolen. This follows the **Least Privilege** principle by restricting the instance to exactly one bucket.

![alt text](./assets/image-36.png)
