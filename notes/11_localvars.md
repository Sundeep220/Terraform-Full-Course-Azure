# ✅ **Terraform Locals**

---

### 🔹 **What are Locals in Terraform?**

* **Locals** are **named expressions** you define once and use multiple times in your Terraform configuration.
* They **do not accept external input** like variables.
* Think of them as **internal constants or computed values** for your Terraform code.

---

### 💡 **Analogy (Programming)**

In programming, locals are like **local variables in a function**:

```java
void createInstance() {
    String instanceName = "web-server-prod";  // Local variable
    System.out.println(instanceName);
}
```

In Terraform:

```hcl
locals {
  instance_name = "web-server-prod"
}
```

Then you can **reuse** it like:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = local.instance_name
  }
}
```

---

### 🔹 **Why Use Locals?**

1. **Avoid repetition** of the same value multiple times
2. **Compute derived values** (like combining variables)
3. **Make code cleaner and more readable**
4. **Avoid hardcoding complex expressions everywhere**

---

### 📝 **Syntax**

```hcl
locals {
  <name> = <expression>
  <name> = <expression>
}
```

* Access using `local.<name>`.

---

### 📄 **Example 1 – Simple Local**

```hcl
locals {
  instance_type = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.instance_type
}
```

---

### 📄 **Example 2 – Derived Values**

Compute values dynamically from **variables**:

```hcl
variable "environment" {
  default = "prod"
}

locals {
  instance_name = "web-${var.environment}"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = local.instance_name
  }
}
```

Resulting **tag name**:

```
web-prod
```

---

### 📄 **Example 3 – Complex Expressions**

```hcl
variable "environment" {
  default = "dev"
}

variable "owner" {
  default = "sundeep"
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.environment}-mybucket"
  tags   = local.common_tags
}
```

✅ This keeps your code **clean and DRY** (Don’t Repeat Yourself).

---

## 🔹 **Key Differences: Variables vs Locals**

| Feature      | Variables (`var`)           | Locals (`local`)     |
| ------------ | --------------------------- | -------------------- |
| Input Source | External (CLI, tfvars, env) | Internal only        |
| Purpose      | Parameterize configuration  | Compute/reuse values |
| Changeable   | User can override           | Cannot override      |
| Analogy      | Function argument           | Local variable       |

---

### ✅ **Best Practices for Locals**

1. **Use locals for computed values** instead of repeating expressions
2. **Combine multiple variables into a local map** for reusable tags or names
3. **Use meaningful names** for clarity
4. **Keep all locals in one `locals.tf` file** for better organization in large projects

---

### ⚡ **Summary**

* **Locals** = Internal reusable variables (cannot be overridden)
* **Access** using `local.name`
* **Use for**: avoiding repetition, computed values, and cleaner code

---