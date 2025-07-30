# ✅ **Terraform Variables – Deep Dive**

---

### 🔹 What are Variables?

* Variables in Terraform are **input parameters** you can define to **avoid hardcoding values** in your `.tf` files.
* They make your code **reusable**, **configurable**, and **environment-agnostic**.

---

### 💡 Analogy (Programming Perspective)

Think of variables like **function parameters**:

```java
// Java function
void createInstance(String instanceType, String region) {
    // logic to create instance
}
```

In Terraform:

```hcl
variable "instance_type" {}
variable "region" {}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
```

---

## 📦 **Types of Variables in Terraform**

Terraform supports multiple variable types.

| Type       | Example                                  | Usage                     |
| ---------- | ---------------------------------------- | ------------------------- |
| **string** | `"us-east-1"`                            | Single string value       |
| **number** | `2` or `3.14`                            | Numeric values            |
| **bool**   | `true` or `false`                        | Boolean flags             |
| **list**   | `["t2.micro", "t2.small", "t2.medium"]`  | Ordered collection        |
| **map**    | `{ env = "prod", region = "us-east-1" }` | Key-value pairs           |
| **object** | `{ name = "web", size = "t2.micro" }`    | Structured key-value      |
| **tuple**  | `["t2.micro", true, 3]`                  | Mixed type ordered values |

---

## 📝 **Ways to Define Variables**

There are **4 main ways** to define variables in Terraform:

---

### **1️⃣ Inline in `.tf` file**

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

* `default` → Optional (used if no other value is provided)
* `type` → Optional (Terraform can infer type automatically)

---

### **2️⃣ Using `.tfvars` File**

File: **terraform.tfvars**

```hcl
instance_type = "t2.small"
region        = "us-west-2"
```

Terraform automatically loads `terraform.tfvars`.

You can also create environment-specific files:

* `dev.tfvars`
* `prod.tfvars`

Then apply with:

```bash
terraform apply -var-file="prod.tfvars"
```

---

### **3️⃣ Inline via CLI**

```bash
terraform apply -var="instance_type=t2.medium" -var="region=us-east-2"
```

---

### **4️⃣ Environment Variables**

Terraform automatically reads variables starting with:

```
TF_VAR_<variable_name>
```

Example (Linux/Mac):

```bash
export TF_VAR_instance_type=t2.large
```

Example (Windows PowerShell):

```powershell
$env:TF_VAR_instance_type="t2.large"
```

---

## 🔹 **Using Variables in Terraform**

Inside `.tf` files, access variables using:

```hcl
  var.<variable_name>
```

Example:

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

---

## 🔹 **Variable Validation (Best Practice)**

You can **validate variables** using `validation` blocks:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small"], var.instance_type)
    error_message = "Instance type must be t2.micro or t2.small."
  }
}
```

---

## 🔹 **Sensitive Variables**

* If variables hold **secrets** (like DB password), mark them `sensitive`:

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

* Terraform will **hide** them from logs and CLI outputs.

---

## ✅ **Best Practices for Variables in Organizations**

1. **Use `variables.tf`** to declare all variables in one place.
2. **Separate environment values** into `.tfvars` files (dev, stage, prod).
3. **Mark secrets as `sensitive`** and load them from environment variables.
4. **Use default values** for common settings, but override for environments.
5. **Use validation blocks** to avoid accidental wrong inputs.
6. **Avoid hardcoding** resource properties — always use variables.

---

### 📂 Recommended Project Structure

```bash
project/
├── main.tf             # Resource definitions
├── variables.tf        # All variable definitions
├── outputs.tf          # Outputs
├── terraform.tfvars    # Default variable values
├── dev.tfvars          # Dev environment variables
└── prod.tfvars         # Production environment variables
```

---

## ✅ **Terraform Variable Precedence (Order of Evaluation)**

Terraform **evaluates variables in the following order of precedence (highest first):**

1. **CLI Flags (`-var` and `-var-file`)**
2. **Environment Variables (`TF_VAR_...`)**
3. **Terraform Variables Files (`.auto.tfvars` and `.tfvars`)**
4. **Default Values in `variable` blocks**

---

### 🔹 **1️⃣ CLI Flags – Highest Priority**

* **`-var`** → Define a variable directly in the CLI
* **`-var-file`** → Provide a variable file explicitly

```bash
terraform apply \
  -var="instance_type=t2.large" \
  -var-file="prod.tfvars"
```

✅ **Overrides everything else.**
💡 Use for **one-off overrides** or CI/CD pipelines.

---

### 🔹 **2️⃣ Environment Variables**

Terraform automatically detects environment variables with the prefix:

```
TF_VAR_<variable_name>
```

Example (Linux/Mac):

```bash
export TF_VAR_instance_type=t2.medium
```

Example (Windows PowerShell):

```powershell
$env:TF_VAR_instance_type="t2.medium"
```

✅ **Overrides tfvars and defaults**
💡 Use for **secrets** or pipeline-based configurations.

---

### 🔹 **3️⃣ Variable Files**

Terraform loads variables from files **in this order**:

1. **`terraform.tfvars`** – Automatically loaded if exists
2. **`*.auto.tfvars`** – Automatically loaded in alphabetical order
3. **Custom tfvars files with `-var-file`** – Loaded explicitly

**Example Project Structure:**

```
project/
├── terraform.tfvars        # default vars
├── dev.auto.tfvars         # auto-loaded for dev
├── prod.auto.tfvars        # auto-loaded for prod
```

---

### 🔹 **4️⃣ Default Values in `variable` Block – Lowest Priority**

If no other value is provided, Terraform falls back to the `default` in the `variable` block:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

---

## 🔹 **Variable Precedence Hierarchy – Summary Table**

| Priority | Source                                | Example Usage                  |
| -------: | ------------------------------------- | ------------------------------ |
| 1 (High) | CLI `-var` / `-var-file`              | `terraform apply -var="x=123"` |
|        2 | Environment Variables (`TF_VAR_name`) | `export TF_VAR_x=123`          |
|        3 | `.auto.tfvars` and `terraform.tfvars` | Automatically loaded files     |
|  4 (Low) | Default value in `variable` block     | `default = "t2.micro"`         |

---

## 🔹 **Real Example of Precedence**

Let's say we define `instance_type` in **4 places**:

1. `variables.tf` → default = `"t2.micro"`
2. `terraform.tfvars` → `"t2.small"`
3. Env Var → `TF_VAR_instance_type="t2.medium"`
4. CLI → `terraform apply -var="instance_type=t2.large"`

**Result** → Terraform will use **`t2.large`** (highest priority = CLI).

---

## ✅ **Best Practices**

* Use **defaults** for common dev settings.
* Use **tfvars files** for environment separation (`dev.tfvars`, `prod.tfvars`).
* Use **environment variables** for sensitive secrets (DB passwords).
* Use **CLI flags** only for **temporary overrides** or **CI/CD**.

---