package spacelift

admins := { "mpalijan", "dschniepp" }

login := input.session.login

admin { admins[login] }
deny  { not admins[login] }
