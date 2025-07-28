Great! Let’s finish this foundational section with:

---

## ✅ **6. Outputs**

### 🔹 What are Outputs in Terraform?

**Outputs** are used to **display useful information** after Terraform has applied your configuration — like IP addresses, resource IDs, names, etc.

Think of outputs as **return values** from your Terraform code.

---

### 💡 Analogy (Programming Perspective):

In a Java or Python function, you often return a result:

```java
public String createVM() {
    return publicIPAddress;
}
```

In Terraform, you write:

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

After `terraform apply`, this will display:

```
Outputs:

instance_ip = "3.122.45.123"
```

---

### 🔍 Why are Outputs Useful?

* To view **critical details** immediately after apply
* For **manual reference**
* To **pass data between modules** (like a return statement)
* For **automation**, when scripting Terraform in pipelines

---

### 📄 How to Write an Output

```hcl
output "<name>" {
  value       = <expression>
  description = "What this value means"   # optional
  sensitive   = true | false              # optional
}
```

Example:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}
```

---

### 🔒 Sensitive Outputs

To prevent secrets (like passwords or tokens) from showing in plain text:

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

---

### 📌 Summary

| Concept       | Explanation                                      |
| ------------- | ------------------------------------------------ |
| What it is    | Displays values after apply (like return values) |
| Analogy       | Like function return or console output           |
| Use Cases     | Show IPs, names, resource IDs, passwords, etc.   |
| Output Syntax | `output "name" { value = <expr> }`               |

---

