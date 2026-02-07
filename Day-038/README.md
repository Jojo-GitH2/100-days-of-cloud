# Day 38: Deploying Containerized Applications with Amazon ECS (Fargate)

## Project Description

Today's task for the Nautilus DevOps team was to modernize our deployment pipeline using **Amazon ECS (Elastic Container Service)**. We adopted a **Serverless Container** approach, removing the need to manage individual servers.

![alt text](./assets/image.png)

**The Goal:**

Package a Python application into a Docker container, store it in a private registry (**ECR**), and orchestrate its execution using the **Fargate Launch Type** to ensure serverless scalability.

## Steps & Configuration

### Step 1: Create Private ECR Repository

1.  Navigate to **Amazon ECR** > **Repositories** > **Create repository**.
2.  **Name:** `datacenter-ecr` (Private).
3.  Note the **Repository URI** for the tagging step.
    ![alt text](./assets/image-1.png)
    ![alt text](./assets/image-2.png)

### Step 2: Build, Tag, and Push (from `aws-client`)

1.  **Authenticate:**

    ```bash
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <YOUR_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
    ```

    ![alt text](./assets/image-3.png)

2.  **Build & Tag:**

    ```bash
    cd /root/pyapp

    docker build -t datacenter-ecr .

    docker tag datacenter-ecr:latest <YOUR_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/datacenter-ecr:latest
    ```

    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-5.png)

3.  **Push:**
    ```bash
    docker push <YOUR_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/datacenter-ecr:latest
    ```
    ![alt text](./assets/image-6.png)

### Step 3: Create ECS Cluster

1.  Navigate to **Amazon ECS** > **Clusters** > **Create cluster**.
    ![alt text](./assets/image-7.png)
    ![alt text](./assets/image-8.png)

2.  **Name:** `datacenter-cluster`.
    ![alt text](./assets/image-9.png)

3.  **Infrastructure:** Selected **AWS Fargate (serverless)**.
    ![alt text](./assets/image-10.png)

### Step 4: Create Task Definition

1.  Navigate to **Task Definitions** > **Create new task definition**.
    ![alt text](./assets/image-11.png)

2.  **Family Name:** `datacenter-taskdefinition`.
    ![alt text](./assets/image-12.png)

3.  **Compute Configuration:**
    - **Launch Type:** Selected **Fargate**. (Crucial for serverless execution).
4.  **Container Details:** - **Name:** `pyapp-container`. - **Image URI:** Pointed to the `datacenter-ecr:latest` URI. - **Resource Allocation:** 0.25 vCPU and 0.5 GB Memory.
    ![alt text](./assets/image-13.png)
    ![alt text](./assets/image-14.png)
    ![alt text](./assets/image-15.png)

### Step 5: Deploy the ECS Service

1.  Inside `datacenter-cluster`, go to **Services** > **Create**.
2.  **Compute Configuration (Deployment):**
    - **Launch Type:** Verified **Fargate** is selected.
3.  **Service Name:** `datacenter-service`.
4.  **Desired Tasks:** 1.
5.  **Networking:** Selected VPC and subnets; ensured a Security Group was created to allow application traffic.
    ![alt text](./assets/image-16.png)
    ![alt text](./assets/image-17.png)
    ![alt text](./assets/image-18.png)
    ![alt text](./assets/image-19.png)
    ![alt text](./assets/image-20.png)
    ![alt text](./assets/image-21.png)
    ![alt text](./assets/image-22.png)
    ![alt text](./assets/image-23.png)

## 🧠 Theory: Launch Type (Fargate vs. EC2)

When creating a Task Definition and Service, choosing the **Launch Type** determines who manages the infrastructure.

- **EC2 Launch Type:** You manage a cluster of EC2 instances. You are responsible for patching the OS and scaling the cluster.
- **Fargate Launch Type:** AWS manages the compute. You only specify the CPU/Memory at the task level. This is truly "Serverless Containers."

![alt text](./assets/image-24.png)
