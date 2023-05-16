package spacelift

webhook[wbdata] {
  endpoint := input.webhook_endpoints[_]
  endpoint.id == "mattermost-spacelift-poc"
  run := input.run_updated.run
  run.state == "FAILED"
  stack := input.run_updated.stack
  wbdata := {
    "endpoint_id": endpoint.id,
    "payload": {
      "text": sprintf("Run ID: %s on stack %s finished with status %s", [run.id, stack.name, run.state])
    },
    "method": "POST",
    "headers": {
      "Content-Type": "application/json",
    },
  }
}

