# Day 35: Deploying a LAMP Stack (EC2 + RDS Integration)

## Project Description

Today's task for the Nautilus DevOps team was to deploy a 2-tier application with a focus on secure database connectivity.
I provisioned a **Private RDS Instance** (`devops-rds`) and connected it to an existing **EC2 Web Server** (`devops-ec2`) running a PHP application.
![alt text](./assets/image.png)

**The Goal:**

Establish a secure connection where the Web Server can talk to the Database, but the Database remains inaccessible from the public internet.

## Steps & Configuration

### Part 1: Provision Private RDS

1.  **Create Database:**
    ![alt text](./assets/image-1.png)
    ![alt text](./assets/image-2.png)
    - **Identifier:** `devops-rds`.
      ![alt text](./assets/image-5.png)

    - **Engine:** MySQL 8.4.5 (Strict requirement).
      ![alt text](./assets/image-3.png)
      ![alt text](./assets/image-4.png)

    - **Instance Class:** `db.t3.micro`.
      ![alt text](./assets/image-6.png)

    - **Storage:** `gp2`, **5 GiB** (Strict requirement).
      ![alt text](./assets/image-7.png)

    - **Credentials:** `devops_admin`. _Note: I generated a password but didn't copy it (simulating a lost credential scenario), necessitating a reset later._
    - **Initial DB Name:** `devops_db`.
      ![alt text](./assets/image-8.png)

    - **Public Access:** **No**.
    - **VPC & Subnet:** Use the same VPC as `devops-ec2`, selecting private subnets.
    - **VPC Security Group:** Create a new one for RDS. I used **rds-sg**
      ![alt text](./assets/image-9.png)

2.  **Wait:** Wait for status to change to **Available**.
    ![alt text](./assets/image-10.png)
    ![alt text](./assets/image-17.png)

### Part 2: Security Group Configuration

_I initially tried to use EC2 Instance Connect, but it failed. I realized I hadn't opened the SSH port._

1.  **EC2 Security Group (Attached to `devops-ec2`):**
    - **Inbound Rule 1:** HTTP (80) from `0.0.0.0/0`.
    - **Inbound Rule 2 (Fix):** SSH (22) from `0.0.0.0/0` (or the Instance Connect IP range).
      ![alt text](./assets/image-14.png)
      ![alt text](./assets/image-15.png)
      ![alt text](./assets/image-16.png)
      ![alt text](./assets/image-24.png)
      ![alt text](./assets/image-25.png)

2.  **RDS Security Group:**
    - **Inbound Rule:** MySQL/Aurora (3306).
    - **Source:** Select the **Security Group ID** of `devops-ec2`.
      ![alt text](./assets/image-11.png)
      ![alt text](./assets/image-12.png)
      ![alt text](./assets/image-13.png)

### Part 3: Key Setup & File Transfer

1.  Check if you a public key exists on your `aws-client` machine:

    ```bash
    cat /root/.ssh/id_rsa.pub
    ```

    ![alt text](./assets/image-19.png)
    - If it doesn't exist, generate one in the next step.

2.  **Generate Key (on `aws-client`):**
    `bash
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
    cat /root/.ssh/id_rsa.pub
    `
    ![alt text](./assets/image-20.png)
    ![alt text](./assets/image-21.png)

3.  **Authorize Key (via Instance Connect):** - Now that Port 22 is open, I used **EC2 Instance Connect** (Browser Console) to log in.
    ![alt text](./assets/image-22.png)
    ![alt text](./assets/image-23.png)
    ![alt text](./assets/image-26.png) - **Crucial Step:** Switch to root user first!
    `bash
      sudo su -
      ` - Add the key to the root user's authorized keys:
    `bash
      echo "ssh-rsa AAAAB3..." >> /root/.ssh/authorized_keys
      `
    ![alt text](./assets/image-27.png)

        - _Keep this browser tab open!_

4.  **Transfer File (on `aws-client`):**
    - Now that the root user is authorized, I can SCP directly:
    ```bash
    scp /root/index.php root@<EC2-PUBLIC-IP>:/var/www/html/
    ```
    ![alt text](./assets/image-28.png)
    ![alt text](./assets/image-29.png)

### Part 4: Configuration & Troubleshooting

_This section required some debugging to get the application live._

1.  **Reset RDS Password:**
    - Since I didn't save the password during creation, I went to **RDS Console** > **Modify** > **New Master Password** and applied the changes immediately.

2.  **Configure PHP Connection (Via Instance Connect):** - In the terminal (as root):

        ```bash
        nano /var/www/html/index.php
        ```

        - Updated with the new credentials:

        ```php
        $dbname = 'devops_db';
        $dbuser = 'devops_admin';
        $dbpass = 'jr2Z7O1WqSKmwBIp1mbN'; // New reset password
        $dbhost = 'devops-rds.cxyssqs6cfsn.us-east-1.rds.amazonaws.com';
        ```
        ![alt text](./assets/image-30.png)

    ![alt text](./assets/image-31.png)
    ![alt text](./assets/image-32.png)

**_Not the Expected Output, to get the page to load correctly, follow the next steps:_**
![alt text](./assets/image-33.png)
![alt text](./assets/image-34.png)

3.  **Fix Apache Directory Index:**
    - The browser was not loading the PHP file by default. I had to tell Apache to prioritize `index.php` over `index.html`.

    ```bash
    nano /etc/apache2/mods-enabled/dir.conf
    ```

    - Changed the order to:

    ```apache
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
    ```

    ![alt text](./assets/image-35.png)
    ![alt text](./assets/image-36.png)

4.  **Restart Web Server:**
    `bash
    systemctl restart apache2.service
    `
    ![alt text](./assets/image-37.png)

### Part 5: Verification

1.  Open your browser and visit `http://<EC2-PUBLIC-IP>`.
2.  **Success:** The page now displays **"Connected successfully"**.
    ![alt text](./assets/image-38.png)

## 🧠 Theory: Troubleshooting the LAMP Stack

This lab wasn't just about deployment; it was about debugging.

1.  **Connectivity:** Failed? Check Security Groups (Port 22/80/3306).
2.  **Permissions:** Cannot add key? Remember to `sudo su -` to become root.
3.  **Application:** White screen? Check `dir.conf`.
4.  **Database:** Access Denied? Reset the password via AWS Console.

![alt text](./assets/image-39.png)
