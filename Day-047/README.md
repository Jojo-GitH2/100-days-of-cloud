# Day 47: Integrating AWS SQS and SNS for Reliable Messaging

## Project Description

Today's task for the Nautilus DevOps team was to implement a robust, decoupled messaging architecture with priority handling. I utilized **AWS CloudFormation** to deploy a Fan-out messaging system where an **SNS Topic** filters messages and routes them to high or low priority **SQS Queues** for processing by a Lambda function.

**The Goal:**

Provision a priority-aware infrastructure using Infrastructure as Code (IaC), ensuring that critical messages are separated from standard traffic at the network level.

## Steps & Configuration

### Step 1: Lambda Code Packaging and Upload

*Before deploying the stack, the Lambda code must be available in an S3 bucket.*

1. **Create S3 Bucket:**
    `aws s3 mb s3://kklabsuser822822`
    ![alt text](image-24.png)

2. **Package Code:**
    `zip function.zip index.py`
3. **Upload to S3:**
    `aws s3 cp function.zip s3://kklabsuser822822`
    ![alt text](image-25.png)

### Step 2: Create the CloudFormation Template

I authored the template at `/root/devops-priority-stack.yml`. This template uses Managed Policies for the IAM role to avoid permission errors associated with inline policy creation.

![alt text](image-26.png)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Priority Queue Processing Stack

Resources:
  HighPriorityQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: devops-High-Priority-Queue
      VisibilityTimeout: 60

  LowPriorityQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: devops-Low-Priority-Queue
      VisibilityTimeout: 60

  PriorityQueuesTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: devops-Priority-Queues-Topic

  HighPrioritySubscription:
    Type: AWS::SNS::Subscription
    Properties:
      TopicArn: !Ref PriorityQueuesTopic
      Protocol: sqs
      Endpoint: !GetAtt HighPriorityQueue.Arn
      FilterPolicy:
        priority:
          - high

  LowPrioritySubscription:
    Type: AWS::SNS::Subscription
    Properties:
      TopicArn: !Ref PriorityQueuesTopic
      Protocol: sqs
      Endpoint: !GetAtt LowPriorityQueue.Arn
      FilterPolicy:
        priority:
          - low 

  HighPriorityPolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues: [!Ref HighPriorityQueue]
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal: "*"
            Action: SQS:SendMessage
            Resource: !GetAtt HighPriorityQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref PriorityQueuesTopic
                
  LowPriorityPolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues: [!Ref LowPriorityQueue]
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal: "*"  
            Action: SQS:SendMessage
            Resource: !GetAtt LowPriorityQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref PriorityQueuesTopic

  LambdaExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: lambda_execution_role
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
        - arn:aws:iam::aws:policy/AmazonSQSFullAccess
        - arn:aws:iam::aws:policy/AmazonSNSFullAccess

  PriorityLambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: devops-priorities-queue-function
      Runtime: python3.9
      Handler: index.lambda_handler
      Role: !GetAtt LambdaExecutionRole.Arn
      Timeout: 5
      Environment:
        Variables:
          high_priority_queue: !Ref HighPriorityQueue
          low_priority_queue: !Ref LowPriorityQueue
      Code:
        S3Bucket: kklabsuser822822
        S3Key: function.zip
```

### Step 3: Deploy the Stack

`aws cloudformation create-stack --stack-name devops-priority-stack --template-body file:///root/devops-priority-stack.yml --capabilities CAPABILITY_NAMED_IAM`

![alt text](image-27.png)

### Step 4: Verification and Testing

1. **Extract Topic ARN:**
`topicarn=$(aws sns list-topics --query "Topics[?contains(TopicArn, 'devops-Priority-Queues-Topic')].TopicArn" --output text)`

2. **Publish High-Priority:**
`aws sns publish --topic-arn $topicarn --message 'High Priority' --message-attributes '{"priority" : { "DataType":"String", "StringValue":"high"}}'`

3. **Result:** Confirmed messages were correctly routed based on attributes and processed by `devops-priorities-queue-function`.

## 🧠 Theory: Decoupling and Managed IAM Identities

- **Subscription Filter Policies:** This lab demonstrates offloading logic from code to infrastructure. By using SNS Filter Policies, the SNS service itself handles the routing logic, ensuring that the High-Priority-Queue only receives relevant traffic.

- **Managed vs. Inline Policies:** To resolve authorization errors (403 Access Denied on iam:PutRolePolicy), this stack utilizes AWS Managed Policies. This follows security best practices in restricted environments where users can attach existing permission sets but cannot create new custom ones.

- **Message Durability:** By placing SQS queues between SNS and Lambda, we ensure the system is resilient. If the Lambda function is throttled, the messages persist in the queues (up to 4 days by default) rather than being lost.
