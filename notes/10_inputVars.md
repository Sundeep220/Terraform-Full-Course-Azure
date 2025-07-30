## ✅ **Terraform Input Variable Types**

Terraform supports **6 primary variable types**:

1. **string**
2. **number**
3. **bool**
4. **list (tuple of same type)**
5. **map (dictionary of same type values)**
6. **object & tuple (complex structured types)**

---

### **1️⃣ string**

**Definition:** A **single text value** (characters in quotes)

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

**Usage in resource:**

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "mybucket-${var.environment}"
}
```

**Use Case:**

* Single values like environment names (`"dev"`, `"prod"`)
* Resource names, regions, or IDs

**Example CLI override:**

```bash
terraform apply -var="environment=prod"
```

---

### **2️⃣ number**

**Definition:** Numeric value (integer or float)

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

**Usage in resource:**

```hcl
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

**Use Case:**

* Scaling resources
* Disk sizes, retention periods, or cost limits

**CLI Example:**

```bash
terraform apply -var="instance_count=5"
```

---

### **3️⃣ bool**

**Definition:** Boolean values `true` or `false`

```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}
```

**Usage in resource (with conditional):**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  monitoring = var.enable_monitoring
}
```

**Use Case:**

* Toggle features (enable/disable monitoring, backups, logging)
* Conditional resource creation (with `count` or `for_each`)

**CLI Example:**

```bash
terraform apply -var="enable_monitoring=true"
```

---

### **4️⃣ list (List of Same Type)**

**Definition:** An **ordered sequence of values** (all same type)

```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
```

**Usage in resource:**

```hcl
resource "aws_subnet" "example" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
}
```

**Use Case:**

* Multiple AZs for subnets or instances
* List of CIDR blocks, users, regions

**CLI Override Example:**

```bash
terraform apply -var='availability_zones=["us-east-1a","us-east-1c"]'
```

---

### **5️⃣ map (Key-Value Pairs)**

**Definition:** A **set of key-value pairs**, like a dictionary

```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "Sundeep"
  }
}
```

**Usage in resource:**

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "mybucket"
  tags   = var.tags
}
```

**Use Case:**

* Tags for resources
* Key-value configuration settings

**CLI Override Example:**

```bash
terraform apply -var='tags={Environment="prod",Owner="TeamX"}'
```

---

### **6️⃣ object & tuple (Complex Structures)**

#### **object**

* Represents a **structured map** with **fixed keys** and **typed values**

```hcl
variable "server_config" {
  type = object({
    instance_type = string
    instance_count = number
    enable_monitoring = bool
  })

  default = {
    instance_type = "t2.micro"
    instance_count = 2
    enable_monitoring = true
  }
}
```

**Usage in resource:**

```hcl
resource "aws_instance" "web" {
  count         = var.server_config.instance_count
  instance_type = var.server_config.instance_type
  monitoring    = var.server_config.enable_monitoring
  ami           = "ami-0c55b159cbfafe1f0"
}
```

**Use Case:**

* Pass **complex configurations** as one variable
* Useful in **modules** to avoid many separate variables

---

#### **tuple**

* Represents an **ordered list with possibly mixed types**

```hcl
variable "example_tuple" {
  type    = tuple([string, number, bool])
  default = ["us-east-1a", 2, true]
}
```

**Use Case:**

* Rarely used directly; useful for **specific mixed data structures**
* Example: `["dev", 3, false]` representing env, count, enabled flag

---

## ✅ **When to Use Which Variable Type**

| Type       | Best For                                                |
| ---------- | ------------------------------------------------------- |
| **string** | Single values (region, env, ID)                         |
| **number** | Counts, sizes, limits                                   |
| **bool**   | Feature flags, toggles                                  |
| **list**   | Multiple items of same type (AZs, CIDRs)                |
| **map**    | Key-value configs (tags, env-specific values)           |
| **object** | Complex structured inputs (server configs, DB settings) |
| **tuple**  | Ordered, mixed-type values (rare, for module inputs)    |

---

### ⚡ **Best Practices for Variables**

1. Use **explicit types** for clarity
2. Keep **environment-specific values in `.tfvars`**
3. Use **maps & objects** for structured and reusable configs
4. Combine **locals + variables** for computed values
5. Validate variables to prevent wrong input

---