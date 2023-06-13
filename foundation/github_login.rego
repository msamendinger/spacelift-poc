package spacelift

admins := { "mpalijan", "dschniepp", "camilofgtp1", "didi-at-work" }

login := input.session.login

admin { admins[login] }
deny  { not admins[login] }
