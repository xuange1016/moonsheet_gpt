///|
test "repository exposes the formula semantic version" {
  inspect(semantic_version, content="moonsheet-formula/1")
}

///|
test "repository starts at milestone zero" {
  inspect(repository_stage(), content="milestone-0")
}
