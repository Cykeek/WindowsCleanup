# Windows Cleanup Script

This batch script cleans temporary files and checks network connectivity on Windows systems.

## Features

- Cleans temporary folders: temp, prefetch, %temp%
- Cleans cache files for Chrome, Edge, and Firefox browsers (if installed)
- Checks network connectivity by pinging www.google.com
- Displays a popup message after successful cleanup
- Logs cleanup activities in logs.txt

## Usage

1. Ensure you have administrative privileges.
2. Download the batch script (`cleanup.bat`) and the popup message script (`popup.vbs`) from this repository.
3. Place both scripts in the same directory.
4. Run `cleanup.bat` with administrative privileges.
5. Follow the prompts to execute the cleanup tasks.
6. After the cleanup is complete, a popup message will indicate successful cleanup.

## Automatic Execution

To execute the script automatically:

1. Open Windows Task Scheduler.
2. Create a new task and give it a name.
3. In the "General" tab, select "Run with highest privileges" option.
4. In the "Triggers" section, choose "At log on" to run the script automatically when you log in to your Windows account.
5. In the "Actions" tab, specify the path to the `cleanup.bat` script.
6. Save the task.

This will ensure that the cleanup script runs automatically with elevated privileges for a smooth experience.

## Contributors

- [Cykeek](https://github.com/Cykeek)

Feel free to contribute by suggesting improvements or reporting issues!

## License

This project is licensed under the [MIT License](https://github.com/Cykeek/WindowsCleanup/blob/test/LICENSE).
