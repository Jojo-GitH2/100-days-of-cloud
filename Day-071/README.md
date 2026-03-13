# Day 71: Assigning Public IP to Virtual Machines

## Project Description

As the Nautilus development team prepares to launch a new application tier, the requirement for a predictable external endpoint has become a priority. Today's task involves the end-to-end provisioning of a **Compute Instance** combined with a **Static Public IP** via the Azure Portal. By shifting from dynamic to static addressing, we ensure that the application's DNS records and firewall allow-lists remain valid even if the virtual machine is restarted or deallocated.

![alt text](image.png)

**The Goal:**

Deploy a `Standard_B1s` Ubuntu VM named `datacenter-vm` and bind it to a dedicated static Public IP resource named `datacenter-pip` using the Azure Portal UI.

## Technical Specifications

| Requirement | Specification |
| :--- | :--- |
| **VM Name** | `datacenter-vm` |
| **VM Size** | `Standard_B1s` (1 vCPU, 1 GiB RAM) |
| **Image** | Ubuntu Server 22.04 LTS |
| **Public IP Name** | `datacenter-pip` |
| **IP Allocation** | Static |
| **Auth Method** | SSH Public Key |

---

## Steps & Configuration (Console/Portal)

### 1. Generate SSH Keys on Azure Client

On the **Azure client host**, I generated a fresh RSA key pair to be used during the VM creation process.

```bash
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
# Copy this public key string for the portal
```

### 2. Create the Virtual Machine & Static IP

1. **Basics Tab:**
   - **Project Details:** Selected the existing resource group.
   - **VM Name:** datacenter-vm.
   - **Region:** Central US.
   - **Image:** Ubuntu Server 22.04 LTS - x64 Gen2.
   - **Size:** Standard_B1s.
   - **Authentication type:** SSH public key.
   - **Username:** azureuser.
   - **SSH public key source:** Use existing public key.
   - **Key:** Pasted the key generated in Step 1.
![alt text](image-2.png)
![alt text](image-3.png)

2. **Networking Tab:**
   - **Public IP:** Clicked Create new.
   - **Name:** datacenter-pip.
   - **SKU:** Standard.
   - **Assignment:** Selected Static.

### 3. Verify External Connectivity

Once the deployment was complete, I retrieved the IP from the Overview blade and tested the connection from the client host.

```bash

# SSH into the VM using the specific private key

ssh azureuser@<DEVOPS-PIP-ADDRESS>
```

## 🧠 Theory: Static vs. Dynamic Public IPs

- **Dynamic (Default):** Assigned by the Azure fabric; it can change if the VM is "Deallocated." This is problematic for services relying on fixed DNS entries.
- **Static Allocation:** Reserved in the Azure infrastructure. It remains assigned to the resource even after restarts or deallocations.
- **Standard SKU:** Standard Public IPs are static by default in modern Azure environments and offer "Secure by Design" features, requiring an explicit Network Security Group (NSG) rule to allow traffic.
