# Day 25: EC2 Instance & CloudWatch Alarm Setup

## Project Description

Today's task for the Nautilus DevOps team involved implementing **Observability**.
I launched a new application server (`devops-ec2`) and immediately attached a **CloudWatch Alarm** to monitor its health.

![alt text](./assets/image.png)

**The Goal:**

Proactively detect performance issues. If the server is working too hard (CPU > 90%), we want to be notified immediately so we can scale up or investigate a potential deadlock.

**Components:**

- **Resource:** EC2 Instance (`devops-ec2`).
- **Monitor:** CloudWatch Alarm (`devops-alarm`).
- **Notification:** SNS Topic (`devops-sns-topic`).

## Steps & Configuration

### Part 1: Launch EC2 Instance

1.  **Log in:** Access the [AWS Management Console](https://aws.amazon.com/console/) and navigate to the **EC2 Dashboard**.
2.  **Launch Instance:**
    - **Name:** `devops-ec2`.
    - **AMI:** Ubuntu (e.g., Ubuntu Server 24.04 LTS).
    - **Instance Type:** `t3.micro` (or any appropriate type).
      ![alt text](./assets/image-1.png)

    - **Key Pair:** Select your existing key or skip it.
    - Click **Launch instance**.
      ![alt text](./assets/image-2.png)
      ![alt text](./assets/image-3.png)

3.  **Get Instance ID:** Copy the Instance ID (e.g., `i-01234abc...`) once it is running. You will need this for the metric selection.

### Part 2: Create CloudWatch Alarm

1.  **Navigate:** Go to the **CloudWatch** service in the console.
    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-5.png)

2.  **Create Alarm:**
    - In the left sidebar, click **All alarms** > **Create alarm**.
      ![alt text](./assets/image-6.png)

3.  **Select Metric:**
    - Click **Select metric**.
    - Browse: **EC2** > **Per-Instance Metrics**.
      ![alt text](./assets/image-7.png)
      ![alt text](./assets/image-8.png)
      ![alt text](./assets/image-9.png)
    - Search for your Instance ID.
      ![alt text](./assets/image-10.png)
      ![alt text](./assets/image-11.png)
    - Select the metric named **CPUUtilization**.
      ![alt text](./assets/image-12.png)

    - Click **Select metric**.

4.  **Configure Metric:**
    - **Statistic:** Average.
    - **Period:** 5 minutes.
    - **Threshold type:** Static.
    - **Condition:** Greater/Equal (`>=`) to **90**.
      ![alt text](./assets/image-13.png)
      ![alt text](./assets/image-14.png)

5.  **Configure Actions:**
    - **Alarm state trigger:** In alarm.
    - **Send a notification to:** Select an existing SNS topic.
    - **Send to:** `devops-sns-topic`.
      ![alt text](./assets/image-15.png)

6.  **Name and Description:**
    - **Alarm name:** `devops-alarm` (Strict requirement).
    - Click **Next** and then **Create alarm**.
      ![alt text](./assets/image-16.png)
      ![alt text](./assets/image-17.png)
      ![alt text](./assets/image-18.png)

## 🧠 Theory: Metrics & Dimensions

- **Metric:** The raw data point (e.g., "CPU %").
- **Dimension:** A filter to specify _which_ resource the metric belongs to (e.g., "InstanceId=i-123...").
- **Period:** The window of time over which data is aggregated (e.g., "Average CPU over 5 minutes").

**Why 5 minutes?**

Standard EC2 monitoring pushes data every 5 minutes. If you want faster alarms (e.g., 1 minute), you must enable "Detailed Monitoring," which costs extra.

![alt text](./assets/image-19.png)
