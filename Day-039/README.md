# Day 39: Hosting a Static Website on AWS S3

## Project Description

The Nautilus DevOps team was tasked with creating an internal information portal. I hosted this portal as a static website using an S3 bucket. This lab involved navigating the security layers of S3 and identifying specific HTTP error codes (**403** and **404**) that occur during the configuration process.

![alt text](./assets/image.png)

**The Goal:**
Provision a public S3 bucket, enable static web hosting, and troubleshoot access permissions before deploying the final `index.html` file.

## Steps & Configuration

### Step 1: Create the S3 Bucket

1.  Created an S3 bucket named `nautilus-web-23944`.
2.  **Public Access:** During creation, I explicitly **unchecked** the "Block all public access" settings to allow for future public hosting.
    ![alt text](./assets/image-1.png)
    ![alt text](./assets/image-2.png)
    ![alt text](./assets/image-4.png)
    ![alt text](./assets/image-3.png)
    ![alt text](./assets/image-5.png)

### Step 2: Configure Static Website Hosting

1.  Navigated to the **Properties** tab and enabled **Static website hosting**.
2.  Set the **Index document** to `index.html`.
    ![alt text](./assets/image-6.png)
    ![alt text](./assets/image-7.png)
    ![alt text](./assets/image-8.png)
    ![alt text](./assets/image-9.png)

3.  **State 1: 403 Forbidden**
    - Visiting the provided S3 website URL at this stage resulted in a **403 Forbidden** error.
    - **Diagnosis:** Disabling "Block Public Access" is not enough; the bucket still lacks an explicit policy to allow anonymous read access.
      ![alt text](./assets/image-10.png)

### Step 3: Apply Bucket Policy

1.  Navigated to **Permissions** > **Bucket Policy**.
2.  Added the following policy to allow `s3:GetObject` for all principals:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::nautilus-web-23944/*"
    }
  ]
}
```

![alt text](./assets/image-11.png)
![alt text](./assets/image-12.png)
![alt text](./assets/image-13.png)

3.  **State 2: 404 Not Found**
    - After saving the policy, refreshing the URL resulted in a **404 Not Found** error.

    - **Diagnosis**: The permissions are now correctly set (the 403 is gone), but the bucket is empty. AWS cannot find the `index.html` file defined in the hosting configuration.
      ![alt text](./assets/image-14.png)

### Step 4: Upload index.html

1. On the `aws-client` host, navigated to the `/root/` directory.

2. Uploaded the file to the bucket using the CLI:

```bash
aws s3 cp index.html s3://nautilus-web-23944/
```

![alt text](./assets/image-15.png)

### Step 5: Verification

1. Accessed the S3 website URL one final time.

2. **Result: 200 OK**. The website content is now visible to the public.
   ![alt text](./assets/image-16.png)
   ![alt text](./assets/image-17.png)

## 🧠 Theory: Status Code Troubleshooting

- **403 Forbidden**: Permission issue. The bucket needs a **Bucket Policy.**

- **404 Not Found**: Content issue. The **index.html** is missing or misspelled in the bucket.

![alt text](./assets/image-18.png)
