# Day 2: Creating Security Groups on AWS

## Project Description

Today's task focused on network security by creating Security Groups in AWS. A Security Group acts as a virtual firewall for your EC2 instances to control incoming and outgoing traffic.

![alt text](./assets/{100AAFDA-8516-42A4-81E3-41DF159054CE}.png)

## Steps & Configuration

### Method 1: Using AWS Management Console

1. Log in to the [AWS Management Console](https://aws.amazon.com/console/).
2. Navigate to the EC2 Dashboard.
3. Click on "Security Groups" in the left sidebar.
4. Click "Create Security Group".
5. Enter a name for your security group and click "Create".
   ![alt text](./assets/{EE39303E-9D38-44E1-97B4-C316B170EF75}.png)
6. **Inbound Rules:** Click "Add rule" and set the following rules:
   - Type: HTTP, Protocol: TCP, Port: 80, Source: Anywhere-IPv4 (0.0.0.0/0).
   - Type: SSH, Protocol: TCP, Port: 22, Source: Anywhere-IPv4 (0.0.0.0/0)
     ![alt text](./assets/{F61028AF-A683-48E0-86E7-4A636DB82891}.png)
7. **Outbound Rules:** By default, all outbound traffic is allowed. You can modify this as needed.

![alt text](./assets/{B8F4E06F-4DED-4789-85F8-8ACFC0BA54F6}.png)

### Method 2: Using AWS CLI

1. Ensure you have the AWS CLI installed and configured with your credentials.
2. Run the following command to create a security group:
   ```bash
   aws ec2 create-security-group --group-name "devops-sg" --description "Security group for Nautilus App Servers"
   ```
   ![alt text](./assets/{D4B6DC5A-C8CE-4CC2-A14D-7B20CA7E94A1}.png)
3. To add an inbound rule (ingress) allowing SSH (port 22) from anywhere:

   **FOR SSH:**

   ```bash
   aws ec2 authorize-security-group-ingress --group-name "devops-sg" --protocol tcp --port 22 --cidr 0.0.0.0/0
   ```

   ![alt text](./assets/{6CB70C7B-99BB-45AC-AD2D-8A9406412705}.png)
4. To add an inbound rule (ingress) allowing HTTP (port 80) from anywhere:
   **FOR HTTP:**

   ```bash
   aws ec2 authorize-security-group-egress --group-name "devops-sg" --protocol -1 --port all --cidr 0.0.0.0/0
   ```

   ![alt text](./assets/{275A2753-5604-498A-8DCD-16A15757B6D0}.png)

5. Verify the security group and its rules:
   ```bash
   aws ec2 describe-security-groups --group-names "devops-sg"
   ```

![alt text](./assets/{75B46195-D2E7-4287-9716-4B06DE74922F}.png)
