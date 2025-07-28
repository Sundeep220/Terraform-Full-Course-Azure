Great idea, Sundeep! Before diving into hands-on, it’s very useful to have a **cheat sheet of all the commonly used Terraform commands**.

Here's a clean and complete list of the **main Terraform commands**, categorized by purpose and with a short explanation for each.

---

## ✅ **🧰 Terraform CLI – Most Common Commands**

| Command | Description |
| ------- | ----------- |

### 🟢 **1. Initialization & Setup**

\| `terraform init`             | Initializes a new or existing Terraform project. Downloads providers and sets up backend. |

---

### 📄 **2. Format & Validate**

\| `terraform fmt`              | Formats your `.tf` files to follow standard Terraform style. |
\| `terraform validate`         | Validates syntax and structure of your configuration files. |

---

### 🔍 **3. Planning & Graphing**

\| `terraform plan`             | Shows what Terraform will do without making any changes (dry run). |
\| `terraform show`             | Displays the contents of the state file in a human-readable format. |
\| `terraform graph`            | Creates a DOT-format graph of the dependency relationships. |

---

### ⚙️ **4. Apply & Change Infrastructure**

\| `terraform apply`            | Applies the changes defined in your configuration to real infrastructure. |
\| `terraform apply -auto-approve` | Skips interactive approval (used in automation/CI-CD). |

---

### 🧨 **5. Destroy Infrastructure**

\| `terraform destroy`          | Deletes all infrastructure managed by Terraform. |
\| `terraform destroy -auto-approve` | Destroys without confirmation. Use with caution! |

---

### 📦 **6. Variables & Outputs**

\| `terraform output`           | Prints the values of output variables defined in `outputs.tf`. |
\| `terraform output <name>`    | Prints the value of a specific output variable. |

---

### 📍 **7. State Management**

\| `terraform state list`       | Lists all resources in the current state file. |
\| `terraform state show <name>` | Shows details of a specific resource from the state file. |
\| `terraform state rm <name>`  | Removes a resource from the state file (without destroying it). |
\| `terraform taint <name>`     | Marks a resource for recreation in the next apply. |
\| `terraform untaint <name>`   | Removes taint so the resource is not recreated. |

---

### 🧳 **8. Workspace Management**

\| `terraform workspace list`   | Lists all existing workspaces (e.g., dev, prod). |
\| `terraform workspace new <name>` | Creates a new workspace. |
\| `terraform workspace select <name>` | Switches to a different workspace. |

---

### 🧵 **9. Module Management**

\| `terraform get`              | Downloads and installs modules referenced in configuration. |
\| `terraform providers`        | Lists the providers used in the configuration and their versions. |

---

### 🧹 **10. Clean Up**

\| `rm -rf .terraform`          | Deletes all Terraform local cache and plugins (manual reset). |

---

## ✅ Most Used Everyday Commands

If you're just starting, these are the **top 7** commands you'll use daily:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

---

