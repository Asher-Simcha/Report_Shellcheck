# Report Shellscript

![Report Shellcheck Icon](https://raw.githubusercontent.com/Asher-Simcha/Report_Shellcheck/main/reportshellcheck.png)

## Overview

**Report Shellscript** is a Linux Bash script designed to analyze your entire system in one pass, generating a detailed report on the condition of each script file as needed. Ideal for system administrators and developers, this tool ensures that every script is scrutinized for potential issues, providing a comprehensive overview of the system's script health.

### Features

- **System-wide Analysis**: Scans common system directories for script files.
- **Shellcheck Integration**: Runs Shellcheck on each script, highlighting files that require attention.
- **Report Generation**: Creates a detailed report saved to a directory named `Report` on the user's Desktop, summarizing the findings.
- **User-Friendly**: Easy to use with minimal configuration required.

![Large Image](https://raw.githubusercontent.com/Asher-Simcha/Report_Shellcheck/main/reportshellcheck_large.png)

## License

This project is licensed under the [2-Clause BSD License](https://opensource.org/license/BSD-2-Clause).

## Getting Started

### Prerequisites

- Linux operating system
- Bash shell
- Shellcheck installed

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/Asher-Simcha/Report_Shellcheck.git
    ```

2. Navigate to the directory:
    ```bash
    cd Report_Shellcheck
    ```

3. Make the script executable:
    ```bash
    chmod 0755 report_shellcheck.sh
    chmod 0755 reportshellcheck_yad.sh
    ```

4. Run the script:
    ```bash
    ./report_shellcheck.sh
    ```
    or run the Desktop Version
    ```bash
    ./reportshellcheck_yad.sh
    ```

### Usage

Simply run the script, and it will analyze the system's script files and generate a report on the Desktop. No additional configuration is required.

### Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes or enhancements.

## Contact

For questions or support, please contact (https://www.facebook.com/groups/648648643592658).
