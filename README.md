# Infra

Remember Me App Infra Repository

## 디렉토리 구조

```bash
❯ tree         
.
├── README.md
├── main.tf
├── modules
│   ├── api_gateway
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── aws_ssm_parameter
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── budgets
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── services.tf
│   │   └── variables.tf
│   ├── chatbot
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam_group_membership
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam_policy
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam_role
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam_role_policy_attachment
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda_layer
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── route53
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── waf
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── templates
│   ├── chatbot-assume-role-policy.json
│   ├── chatbot-budget-policy.json
│   ├── chatbot-policy.json
│   ├── dev-policy.json
│   ├── infra-policy.json
│   ├── lambda
│   │   ├── code
│   │   │   ├── index.js
│   │   │   └── index.py
│   │   ├── lambda_layer.zip
│   │   ├── lambda_nodejs_code.zip
│   │   ├── lambda_python_code.zip
│   │   └── layer
│   │       ├── layer.js
│   │       └── layer.py
│   ├── lambda-assume-role-policy.json
│   ├── lambda-policy.json
│   ├── s3-policy.json
│   ├── sns-topic-policy-budget.json
│   └── sns-topic-policy.json
├── variables.tf
└── versions.tf

20 directories, 64 files
```
