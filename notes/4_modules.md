Awesome! Let’s now explore the next key concept:

---

## ✅ **3. Modules**

### 🔹 What is a Module?

A **module** in Terraform is like a **reusable block of configuration** – a group of related resources bundled together.

You use modules to:

* **Avoid duplication**
* **Organize your code**
* **Make your configurations cleaner and more maintainable**

---

### 💡 Analogy (Programming Perspective):

Think of a module like a **function or class** in programming.

```java
public class VPCModule {
    public void createVPC(String cidr) {
        // logic to create VPC
    }
}
```

Instead of repeating VPC logic every time, you just **call** the module.

In Terraform:

```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}
```

* `module` → Keyword to use a module
* `"vpc"` → The name you're giving this module instance
* `source` → Path to the module (local folder, Git repo, or Terraform Registry)
* Other values → Inputs to configure the module

---

### 🛠️ What does a Module Contain?

A module is usually a folder with:

| File           | Purpose                        |
| -------------- | ------------------------------ |
| `main.tf`      | Main logic for resources       |
| `variables.tf` | Inputs to the module           |
| `outputs.tf`   | Values that the module returns |

---

### 📁 Example Folder Structure

```bash
.
├── main.tf
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

### ✅ Benefits of Using Modules

* DRY (Don’t Repeat Yourself)
* Easy to test and reuse
* Clean and scalable Terraform code

---

### 📌 Summary

| Concept    | Explanation                                  |
| ---------- | -------------------------------------------- |
| What it is | A reusable block of Terraform configurations |
| Analogy    | Like a function or class in code             |
| Example    | `module "vpc" { source = "./modules/vpc" }`  |

---
