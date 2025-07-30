# ✅ **What are Type Constraints in Terraform?**

* **Type constraints** specify **what kind of values** a variable can accept.
* They are **enforced at plan time** (Terraform will throw an error if you pass the wrong type).
* They make your code **robust and self-documenting**.

---

## 🔹 **Basic Type Constraints**

Terraform has **3 basic type constraints**:

1. **string**
2. **number**
3. **bool**

---

### **1️⃣ string**

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}
```

✅ Accepts: `"us-east-1"`
❌ Rejects: `["us-east-1", "us-west-1"]`

---

### **2️⃣ number**

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

✅ Accepts: `2` or `3.5`
❌ Rejects: `"two"`

---

### **3️⃣ bool**

```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}
```

✅ Accepts: `true` / `false`
❌ Rejects: `"yes"` / `"0"`

---

## 🔹 **Complex Type Constraints**

Terraform allows **collections and structural types**:

1. **list(type)** – Ordered collection of **same type**
2. **set(type)** – Unordered collection of **unique values**
3. **map(type)** – Key-value pairs of **same value type**
4. **object({...})** – Custom structure with **named attributes**
5. **tuple(\[...])** – Ordered list of **mixed types**

---

### **1️⃣ list(type)**

```hcl
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
```

* **Maintains order**
* Access via index → `var.azs[0]`

**Use Case:** Subnets per AZ, list of AMIs

---

### **2️⃣ set(type)**

```hcl
variable "unique_users" {
  type    = set(string)
  default = ["alice", "bob", "alice"] # duplicates auto-removed
}
```

* **No duplicates**
* **No guaranteed order**

**Use Case:** IAM users, security group CIDRs

---

### **3️⃣ map(type)**

```hcl
variable "instance_types" {
  type = map(string)
  default = {
    dev   = "t2.micro"
    prod  = "t2.large"
  }
}
```

Access with key:

```hcl
instance_type = var.instance_types["prod"]
```

**Use Case:** Env-based configs, tagging

---

### **4️⃣ object({...})**

**Structured collection with named attributes and type constraints**

```hcl
variable "server_config" {
  type = object({
    instance_type    = string
    instance_count   = number
    enable_monitoring = bool
  })
  default = {
    instance_type    = "t2.micro"
    instance_count   = 2
    enable_monitoring = true
  }
}
```

* Access like:

```hcl
var.server_config.instance_type
```

**Use Case:** Passing structured configs to **modules**
**Enterprise Tip:** Use objects for **consistent team-wide configuration standards**

---

### **5️⃣ tuple(\[...])**

**Ordered collection of fixed types and length**

```hcl
variable "example_tuple" {
  type    = tuple([string, number, bool])
  default = ["us-east-1a", 2, true]
}
```

* Mixed type but **position-dependent**
* Access with index → `var.example_tuple[1]` → `2`

**Use Case:** Rarely used; mostly for **module interface constraints**

---

## 🔹 **Dynamic Types (any)**

* If no type is defined, variable defaults to `any`
* Accepts **any type** (not recommended for enterprise projects)

```hcl
variable "dynamic_value" {
  type = any
}
```

**Use Case:**

* Prototyping
* Accepting different structures in **shared modules**

⚠️ **Risk**: Can lead to unexpected errors later.

---

## ✅ **Best Practices for Type Constraints**

1. **Always specify type** for input variables (avoid `any` in production)
2. Use **collection types** for structured data (list, map, object)
3. Use **object** for module inputs (makes API clear and strict)
4. Use **validation blocks** with type constraints for extra safety
5. Use **set** when you don’t care about order but need uniqueness

---

### 📄 **Example: Combining Types + Validation**

```hcl
variable "azs" {
  type = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "At least two AZs are required for high availability."
  }
}
```

---