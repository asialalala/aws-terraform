output "state_machine_arn" {
  value = aws_sfn_state_machine.my_workflow.arn
}

output "state_machine_name" {
  value = aws_sfn_state_machine.my_workflow.name
}