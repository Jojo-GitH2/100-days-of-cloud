# Day 46: Event-Driven Processing with Amazon S3 and Lambda

## Project Description

Today's task for the Nautilus DevOps team was to implement an automated, event-driven data pipeline. I built a system where a file upload to a public S3 bucket triggers an AWS Lambda function to move that file to a secure private bucket and log the metadata into a DynamoDB table.
![alt text](./assets/image.png)

**The Goal:**

Automate secure file transfers and audit logging using serverless architecture, ensuring every upload is tracked and safely stored without manual intervention.

## Steps & Configuration

### Step 1: Resource Preparation (S3 & DynamoDB)

1. **Public Bucket:** Created `devops-public-7749`. Disabled "Block all public access" and added a policy for public `s3:GetObject`.
   ![alt text](./assets/image-1.png)
   ![alt text](./assets/image-2.png)
   ![alt text](./assets/image-3.png)
   ![alt text](./assets/image-4.png)

2. **Private Bucket:** Created `devops-private-22586` with all public access blocked.
   ![alt text](./assets/image-5.png)
   ![alt text](./assets/image-6.png)
   ![alt text](./assets/image-7.png)

3. **DynamoDB Table:** Created `devops-S3CopyLogs` with Partition Key `LogID` (String).
   ![alt text](./assets/image-8.png)
   ![alt text](./assets/image-9.png)

### Step 2: IAM Policy and Role Creation (The "Policy-First" Workflow)

_To ensure the role attachment is successful, I defined the permissions before the identity._

1. **Create Custom IAM Policy:** Created a policy with the following precise permissions:
   _**S3 (Source):** `s3:GetObject` on `arn:aws:s3:::devops-public-7749/_`    * **S3 (Destination):**`s3:PutObject`on`arn:aws:s3:::devops-private-22586/_`
   _ **DynamoDB:** `dynamodb:PutItem` on `arn:aws:s3:::devops-S3CopyLogs` \* **CloudWatch Logs:** `logs:CreateLogGroup`, `logs:CreateLogStream`, and `logs:PutLogEvents`
   ![alt text](./assets/image-10.png)
   ![alt text](./assets/image-11.png)

2. **Create IAM Role:** Created `lambda_execution_role` with Lambda as the trusted service.
3. **Attachment:** Attached the newly created custom policy to the `lambda_execution_role`.
   ![alt text](./assets/image-12.png)
   ![alt text](./assets/image-13.png)

### Step 3: Configure Lambda Function

1. **Function Name:** `devops-copyfunction`.
2. **Role:** Linked the `lambda_execution_role`.
   ![alt text](./assets/image-14.png)
   ![alt text](./assets/image-15.png)
   ![alt text](./assets/image-16.png)

3. **Code:** Used `lambda-function.py` from `/root/` and performed these replacements:
   - `REPLACE-WITH-YOUR-DYNAMODB-TABLE` -> `devops-S3CopyLogs`
   - `REPLACE-WITH-YOUR-PRIVATE-BUCKET` -> `devops-private-22586`
4. **Trigger:** Added an S3 trigger for `devops-public-7749` on **All object create events**.
   ![alt text](./assets/image-17.png)
   ![alt text](./assets/image-18.png)

### Step 4: Testing & Verification

1. **Upload:** From the `aws-client` host:

   ```bash
   aws s3 cp /root/sample.zip s3://devops-public-7749/
   ```

   ![alt text](./assets/image-19.png)

2. **S3 Check:** Verified `sample.zip` was automatically copied to `devops-private-22586`.
   ![alt text](./assets/image-20.png)

3. **DynamoDB Check:** Confirmed the log entry exists in `devops-S3CopyLogs` containing the Source Bucket, Destination Bucket, and Object Key.
   ![alt text](./assets/image-21.png)

## 🧠 Theory: Event-Driven Architecture and Serverless Triggers

The core concept of today's activity is the **Event-Driven Design Pattern**:

- **S3 Event Notifications:** S3 acts as an event producer. When an object is created, it sends a JSON payload containing the object details to the Lambda service.
- **Decoupling:** The public bucket doesn't know what happens to the file; it simply announces that a file exists. This allows us to scale the destination (Private S3) or the logging (DynamoDB) independently.
- **Lambda as an Orchestrator:** Lambda acts as the compute layer that lives only for the duration of the execution (seconds). It retrieves the data from the event, uses the SDK (Boto3) to interact with S3 and DynamoDB, and shuts down, making it highly cost-efficient.
- **Audit Logging:** By integrating DynamoDB, we create an immutable record of data movement. This is a critical DevOps practice for compliance and troubleshooting in automated pipelines.
  ![alt text](./assets/image-22.png)
