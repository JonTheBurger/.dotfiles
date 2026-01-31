# Commands to run in interactive sessions can go here
if status is-interactive
  # Custom backward-kill-word that stops at /
  function backward-kill-path-component
    # Get the current command line and cursor position
    set -l cmd (commandline)
    set -l pos (commandline -C)

    # Get the part before cursor
    set -l before (string sub -l $pos -- $cmd)

    # Remove trailing slashes if cursor is right after one
    set before (string replace -r '/*$' '' -- $before)

    # Find the last / and delete back to it (keeping the /)
    if string match -qr '/' -- $before
      set before (string replace -r '[^/]*$' '' -- $before)
      set -l after (string sub -s (math $pos + 1) -- $cmd)
      commandline -r -- $before$after
      commandline -C (string length -- $before)
    else
      # No / found, delete to beginning of token
      commandline -f backward-kill-word
    end
  end

  # Bind alt+backspace to the custom function
  bind \e\x7f backward-kill-path-component

  # ==================================================================================== #

  function auto-venv --on-variable PWD
      # Deactivate if we have a venv active and we're not in its directory anymore
      if set -q VIRTUAL_ENV
          set -l venv_dir (dirname (dirname $VIRTUAL_ENV))
          if not string match -q "$venv_dir*" $PWD
              deactivate
          end
      end
      
      # Activate if .venv exists in current directory
      if test -d .venv/bin/activate.fish
          source .venv/bin/activate.fish
      end
  end

  auto-venv
end
