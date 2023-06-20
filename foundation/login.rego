package spacelift

admins := { "mpalijan", "dschniepp", "camilofgtp1", "didi-at-work", "Marc Samendinger", "Mladen Palijan", "Dieter Rothacker", "Camilo Fernandez", "Daniel Schniepp", "Martin Wahl" }

login := input.session.name

admin { admins[login] }
deny  { not admins[login] }

sample = true
