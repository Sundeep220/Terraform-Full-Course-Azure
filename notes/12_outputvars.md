# ✅ **Terraform Output Variables**

---

### 🔹 **What are Output Variables?**

* **Output variables** are the **values Terraform returns** after applying a configuration.
* They help you **see important info** like:

    * Public IP of a server
    * S3 bucket name
    * DB connection string
* Outputs can also **pass values between modules** or **to your CI/CD pipeline**.

---

### 💡 **Analogy (Programming)**

Think of **outputs like function return values**:

```java
public String createEC2() {
    return ec2PublicIP;  // Return the IP to caller
}
```

In Terraform:

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

After `terraform apply`:

```
Outputs:

instance_ip = "54.210.12.34"
```

---

## 🧩 **Use Cases of Output Variables**

1. **Display useful info** after deployment

    * Example: Show EC2 instance IPs
2. **Share data between modules**

    * Example: VPC module outputs the VPC ID to be used in subnet module
3. **Use in CI/CD pipelines**

    * Example: Pipeline reads outputs to trigger other deployments

---

### 📝 **Syntax**

```hcl
output "<output_name>" {
  value       = <expression>
  description = "optional explanation"
  sensitive   = true/false
}
```

* `value` → Required (what you want to output)
* `description` → Optional (good for readability)
* `sensitive` → Optional (hides value from CLI logs)

---

### 📄 **Example 1 – Simple Output**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

output "instance_id" {
  value = aws_instance.web.id
}
```

After `terraform apply`:

```
Outputs:

instance_id = "i-0abc123def456ghi7"
```

---

### 📄 **Example 2 – Sensitive Output**

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

* CLI will show:

```
db_password = <sensitive>
```

* **Hidden from logs** but still **accessible for automation**.

---

### 📄 **Example 3 – Output Lists and Maps**

```hcl
output "instance_ips" {
  value = aws_instance.web[*].public_ip
}

output "tags_map" {
  value = {
    env    = "prod"
    owner  = "sundeep"
  }
}
```

* Can output **lists**, **maps**, and **complex objects**.

---

## 🔹 **Accessing Outputs**

### 1️⃣ After Apply in CLI

```bash
terraform output
terraform output instance_ip
```

### 2️⃣ From Another Module

**Parent Module:**

```hcl
module "vpc" {
  source = "./modules/vpc"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

**Inside `modules/vpc/outputs.tf`:**

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

---

### ✅ **Best Practices for Outputs**

1. **Output only useful values** (IPs, IDs, names)
2. **Mark secrets as `sensitive`**
3. **Use outputs to link modules together**
   (Don’t hardcode resource IDs between modules)
4. **Provide descriptions** for clarity
5. **Avoid exposing unnecessary sensitive data** in CI/CD logs

---

### ⚡ **Summary**

| Feature        | Description                                              |
| -------------- | -------------------------------------------------------- |
| Purpose        | Return useful info after `terraform apply`               |
| Analogy        | Function return value                                    |
| Sensitive Data | Use `sensitive = true`                                   |
| Use Case       | Show IPs, share VPC IDs, pass DB URIs                    |
| Access Syntax  | `terraform output <name>` or `module.module_name.output` |

---
