locals {
  resources_w_iam_role = {
    for k, r in var.resource_selection :
    k => r if lookup(r, "iam_role", null) != null && lookup(r, "iam_role_arn", null) == null
  }
}

module "resource_roles" {
  source   = "git::git@github.com:jampp/terraform-aws-iam-module.git//modules/inline-role?ref=v1.0.0"
  for_each = local.resources_w_iam_role

  role_name               = lookup(each.value.iam_role, "name", "${each.key}-backup-role")
  assume_role_policy_file = "${path.module}/files/assume-policy.json"
  assume_role_policy_vars = {}

  inline_policies = merge(
    {
      "aws-backup" = {
        file = "${path.module}/files/aws-backup-policy.json"
        vars = {}
      }
    },
    lookup(each.value.iam_role, "inline_policies", {})
  )

  tags = merge(
    lookup(each.value.iam_role, "tags", {}),
    var.tags
  )
}

# Resource selection
resource "aws_backup_selection" "resources" {
  for_each = var.resource_selection

  name         = each.key
  iam_role_arn = lookup(each.value, "iam_role_arn", null) != null ? each.value.iam_role_arn : module.resource_roles[each.key].arn
  plan_id      = lookup(each.value, "plan_id", var.plan_id)

  dynamic "selection_tag" {
    for_each = lookup(each.value, "selection_tags", {})

    content {
      key   = selection_tag.key
      type  = selection_tag.value.type
      value = selection_tag.value.value
    }
  }

  condition {

    dynamic "string_equals" {
      for_each = {
        for k, cond in lookup(each.value, "conditions", {}) : k => cond
        if cond.condition == "STRINGEQUALS"
      }

      content {
        key   = string_equals.key
        value = string_equals.value.value
      }
    }

    dynamic "string_like" {
      for_each = {
        for k, cond in lookup(each.value, "conditions", {}) : k => cond
        if cond.condition == "STRINGLIKE"
      }

      content {
        key   = string_equals.key
        value = string_equals.value.value
      }
    }

    dynamic "string_not_equals" {
      for_each = {
        for k, cond in lookup(each.value, "conditions", {}) : k => cond
        if cond.condition == "STRINGENOTQUALS"
      }

      content {
        key   = string_equals.key
        value = string_equals.value.value
      }
    }

    dynamic "string_not_like" {
      for_each = {
        for k, cond in lookup(each.value, "conditions", {}) : k => cond
        if cond.condition == "STRINGNOTLIKE"
      }

      content {
        key   = string_equals.key
        value = string_equals.value.value
      }
    }
  }

  resources     = lookup(each.value, "resources", [])
  not_resources = lookup(each.value, "not_resources", [])
}
