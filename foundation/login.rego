package spacelift

admins := { "mpalijan", "dschniepp", "camilofgtp1", "didi-at-work", "Marc Samendinger" }

login := input.session.login

admin { admins[login] }
deny  { not admins[login] }
