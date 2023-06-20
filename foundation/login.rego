package spacelift

admins := { "mpalijan", "dschniepp", "camilofgtp1", "didi-at-work", "Marc Samendinger" }

login := input.session.name

admin { admins[login] }
deny  { not admins[login] }

sample = true
