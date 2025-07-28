Awesome! Let’s now cover another core concept:

---

## ✅ **5. Variables**

### 🔹 What are Variables in Terraform?

**Variables** allow you to **parameterize** your Terraform configurations — making them **dynamic**, **reusable**, and **clean**.

You don’t want to hardcode values like region, instance size, or names. Instead, use variables to inject them from outside.

---

### 💡 Analogy (Programming Perspective):

Think of variables in Terraform just like **function parameters** or **variables in code**:

```java
public void createVM(String instanceType) {
    // use instanceType in logic
}
```

In Terraform:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

You can then **use** that variable like:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-abc123"
  instance_type = var.instance_type
}
```

---

### 📦 Types of Variables

| Type   | Example                                      |
| ------ | -------------------------------------------- |
| string | `"us-east-1"`                                |
| number | `2`, `3.14`                                  |
| bool   | `true`, `false`                              |
| list   | `["t2.micro", "t2.medium"]`                  |
| map    | `{ "env" = "prod", "region" = "us-east-1" }` |

---

### 📄 How to Define & Use Variables

#### 1. Define (in `variables.tf`)

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}
```

#### 2. Use (in `main.tf`)

```hcl
provider "aws" {
  region = var.region
}
```

#### 3. Set values (3 ways)

| Method         | How?                                      |
| -------------- | ----------------------------------------- |
| Default        | Set in `variable` block                   |
| CLI            | `terraform apply -var="region=us-west-2"` |
| `.tfvars` file | Add to `terraform.tfvars`                 |

Example `terraform.tfvars`:

```hcl
region = "us-west-1"
```

---

### 📌 Summary

| Concept       | Explanation                                    |
| ------------- | ---------------------------------------------- |
| What it is    | Input parameters to make your configs reusable |
| Analogy       | Like function arguments or config variables    |
| Used for      | Avoiding hardcoding, making config dynamic     |
| Access Syntax | `var.variable_name`                            |

---
