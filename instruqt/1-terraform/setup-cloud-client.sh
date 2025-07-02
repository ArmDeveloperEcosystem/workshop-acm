# Generate a .screenrc file
# We use a Bash HEREDOC to create the ~/.screenrc file.
cat > ~/.screenrc <<-EOF 
# ~/.screenrc configuration file

# Set the default shell
shell "/bin/bash"

# Disable the startup message
startup_message off

# Disable Visual Bell
vbell off

# Increase the scrollback buffer
defscrollback 5000

EOF

