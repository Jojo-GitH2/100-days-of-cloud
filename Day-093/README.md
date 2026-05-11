# Day 93: Configuring Azure VM with Application Gateway

## Project Description

As the Nautilus project matures, we are moving from basic Level 4 load balancing to **Level 7 Application Delivery**. Today's task involves placing our Nginx web server behind an **Azure Application Gateway (AGW)**. Unlike a standard load balancer, the AGW is a web traffic load balancer that enables us to manage traffic to our web applications based on URL paths, SSL termination, and cookie-based session affinity.

![alt text](./assets/image.png)

**The Goal:**
Deploy an Ubuntu VM (`datacenter-vm`) running Nginx and route traffic to it through an Application Gateway (`datacenter-agw`) using a custom listener, backend pool, and routing rules.

## Technical Specifications

| Component | Specification |
| :--- | :--- |
| **VM Name** | `datacenter-vm` |
| **VM Size** | `Standard_B1s` (1 vCPU, 1 GiB RAM) |
| **Storage SKU** | `Standard HDD` |
| **NSG Name** | `datacenter-nsg` |
| **App Gateway** | `datacenter-agw` |
| **Frontend IP** | `datacenter-agw-ip` (Public) |
| **Backend Pool** | `datacenter-backendpool` |
| **HTTP Settings** | Port 80 (`datacenter-http-settings`) |

---

## Steps & Configuration

### 1. Network Security Group (NSG) Setup

I created the `datacenter-nsg` first to define the "Security Perimeter" for our backend VM.

* **Rule Name:** `Allow-HTTP`
* **Priority:** `100`
* **Port:** `80`
* **Protocol:** `TCP`
* **Action:** `Allow`

![alt text](./assets/image-1.png)

![alt text](./assets/image-2.png)

![alt text](./assets/image-3.png)

### 2. Provision the Virtual Machine

I launched the `datacenter-vm` using an Ubuntu image.

1. **Authentication:** Generated an SSH key locally on the `azure-client` (`cat ~/.ssh/id_rsa.pub`) and pasted it into the portal.
2. **Storage:** Selected **Standard HDD** for cost-effectiveness.
3. **User Data Script:**

    ```bash
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```

![alt text](./assets/image-4.png)

![alt text](./assets/image-5.png)

![alt text](./assets/image-6.png)

![alt text](./assets/image-7.png)

![alt text](./assets/image-8.png)

1. **Networking:** Attached the `datacenter-nsg`.
   ![alt text](./assets/image-9.png)

### 3. Deploy the Application Gateway (AGW)

This was the core orchestration step. AGW requires a dedicated subnet within the VNet.

1. **Frontend:** Created and associated the Public IP `datacenter-agw-ip`.
2. **Backend Pool:** Created `datacenter-backendpool` and added the `datacenter-vm` target.
3. **HTTP Settings:** Created `datacenter-http-settings` targeting Port 80.
4. **Listener:** Created `datacenter-listener` to listen on the Public IP on Port 80 (HTTP).
5. **Routing Rule:** Created `datacenter-routing-rule` to bridge the `datacenter-listener` to the `datacenter-backendpool`.

![alt text](./assets/image-10.png)

![alt text](./assets/image-11.png)

![alt text](./assets/image-12.png)

![alt text](./assets/image-13.png)

![alt text](./assets/image-14.png)

![alt text](./assets/image-15.png)

![alt text](./assets/image-16.png)

![alt text](./assets/image-17.png)

---

## Verification

1. **Deployment State:** Waited for the AGW status to transition from `Updating` to `Running`.
2. **Public Access:** Retrieved the Public IP of the `datacenter-agw-ip`.
3. **URL Test:** Navigated to `http://<AGW_PUBLIC_IP>`.
4. **Result:** The "Welcome to Nginx" page appeared, confirming traffic is successfully flowing from the internet ➡️ AGW ➡️ VM.

![alt text](./assets/image-18.png)

## 🧠 Theory: Load Balancer (L4) vs. Application Gateway (L7)

* **Layer 4 (Load Balancer):** Operates at the transport level (IPs and Ports). It doesn't "see" the website content; it just shifts packets.
* **Layer 2 (Application Gateway):** Operates at the application level. It understands HTTP headers and URIs. This allows for advanced features like:
  * **URL Path-Based Routing:** Send `/images` to one pool and `/api` to another.
  * **SSL Termination:** Offload the heavy work of decrypting HTTPS traffic to the gateway, freeing up the VM.
  * **Web Application Firewall (WAF):** Protection against common web vulnerabilities (SQL injection, XSS).
  
![alt text](./assets/image-19.png)
