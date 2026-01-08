# Day 8: Enable Stop Protection for EC2

## Project Description

Today's task involved securing a critical instance against accidental shutdowns. The scenario involved the `nautilus-ec2` instance in the `us-east-1` region. To ensure stability during ongoing changes, I enabled **Stop Protection**.
![alt text](image.png)

**What is Stop Protection?**
It prevents an instance from being stopped via the AWS Console, CLI, or API. This is crucial for instances that run critical stateful applications where a shutdown could result in data corruption or extended downtime.

## Steps & Configuration

### Method: Using AWS Management Console

1. Log in to the [AWS Management Console](https://aws.amazon.com/console/).
2. Navigate to the **EC2 Dashboard**.
3. Select the instance named `nautilus-ec2`.
   ![alt text](image-1.png)

4. Click on **Actions** > **Instance Settings** > **Change Stop Protection**.
   ![alt text](image-2.png)
5. In the dialog box, check the box for **Enable** Stop Protection and click **Save**.
   ![alt text](image-3.png)
6. Verify that Stop Protection is enabled by checking the instance details.
   ![alt text](image-4.png)

![alt text](image-5.png)

## Theory: Stop vs. Termination Protection

It is important to distinguish between the two:

- Termination Protection: Prevents the instance from being deleted (Terminated).

- Stop Protection: Prevents the instance from being shut down (Stopped). You often need both for critical production workloads.
