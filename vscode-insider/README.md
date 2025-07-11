# VS Code Insiders Extensions & Settings Sync

## Export Extensions

To export your current extensions list:

```sh
code-insiders --list-extensions > vscode-insider/extensions.txt
```

## Restore Extensions

To restore extensions on a new machine:

```sh
cd vscode-insider
zsh restore.sh
```

## Sync Settings & Keybindings

This repo stores your `settings.json` and `keybindings.json` for VS Code Insiders. The restore script will symlink them to the correct location on macOS.

## Notes

- For other OSes, adjust the script paths as needed.
- For full state sync (snippets, UI state), copy additional files from `~/Library/Application Support/Code - Insiders/User/`.
- For built-in cloud sync, use VS Code's Settings Sync feature (see docs: https://code.visualstudio.com/docs/editor/settings-sync).
