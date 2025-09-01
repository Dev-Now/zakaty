# Zakaty - Zakat Calculation App

![Zakaty Logo](assets/icons/logo.png)

Zakaty is a Windows desktop application designed to help Muslims calculate their Zakat (Islamic charitable giving) accurately and efficiently. The app provides an intuitive interface for managing multiple calculation sheets, tracking savings across different currencies, and computing Zakat obligations according to Islamic principles.

## Features

- **Multi-Sheet Management**: Create and manage multiple Zakat calculation sheets
- **Multi-Currency Support**: Handle savings in different currencies with automatic conversion
- **Live Calculations**: Real-time Zakat computation as you enter your financial data
- **Historical Tracking**: Save and access your previous Zakat calculations
- **Flexible Date Management**: Set specific due dates for accurate currency conversion rates
- **Advanced Zakat Tracking**: Track Zakat payments made in advance
- **Exploration Mode**: Practice and explore app features with a temporary sheet

## Installation

### System Requirements

- **Operating System**: Windows 10 or later
- **Disk Space**: At least 100MB of free disk space
- **Memory**: 4GB RAM recommended
- **Internet Connection**: Required for currency conversion rates

### Installation Steps

1. Download the latest `zakaty_setup.exe` from the [Releases page](https://github.com/Dev-Now/zakaty/releases)
2. Run the installer
3. Follow the installation wizard instructions
4. Launch the application from the Start Menu or desktop shortcut

### Troubleshooting Installation

If the application doesn't start after installation:
- Ensure you have administrative rights on your computer
- Check if Windows Defender or your antivirus software is blocking the application
- Try running the application as administrator
- Verify that your system meets the minimum requirements

## Quick Start Guide

### First Time Setup

1. **Launch the Application**: Start Zakaty from your Start Menu
2. **Explore the App**: The app starts with an "Exploration sheet" that allows you to familiarize yourself with the interface
3. **Create Your First Sheet**: Click "Add new calculation sheet" button to create a new calculation sheet

### Basic Usage

For instructions on using the app, refer to the help section within the app by clicking the icon on the header.

### Understanding the Interface

#### Sheet Header
The header displays your calculation summary:
- **Sheet Title**: Name of your current calculation sheet
- **Total Savings**: Sum of all your savings in the target currency
- **Calculated Zakat**: 2.5% of your total savings
- **ToDo Amount**: Remaining Zakat you need to pay

#### Adding Amounts
- **Savings**: Regular savings entries (bank accounts, cash, etc.)
- **Advanced Zakat**: Zakat payments made before or after the due date
  - Toggle "Include in savings" based on when the payment was made

## Configuration

The application creates its configuration files automatically on first run. Configuration files are stored in:

```
%APPDATA%\com.example\zakaty\config.json
```

### Customizable Settings

You can edit the configuration file to:
- Add or modify supported currencies (The default currency is the first in the list)
- Set a custom working directory for your calculation files

### Configuration File Format

The configuration file uses JSON format. Example structure:
```json
{
  "workingDirectory": "path/to/your/calculations",
  "currencyOptions": ["USD", "EUR", "GBP", "SAR", "AED"],
}
```

## Zakat Calculation Rules

This application follows standard Islamic Zakat principles:
- **Rate**: 2.5% of total eligible savings
- **Hawl Requirement**: The app assumes you've owned the Nisab for a full Hijri year
- **No Nisab Threshold**: The app does not automatically check Nisab thresholds - users should ensure their savings meet the minimum requirements

> **Note**: This app is a calculation tool. Please consult with Islamic scholars for complex Zakat rulings and to ensure compliance with your followed Islamic jurisprudence.

## Data Privacy & Security

- All calculations are stored locally on your computer
- No financial data is transmitted to external servers
- Currency conversion rates are fetched from public APIs when needed
- Your personal information and calculation data remain private

## Support & Contributing

### Getting Help

If you encounter issues or have questions:
1. Check the [Troubleshooting](#troubleshooting-installation) section
2. Search existing [Issues](https://github.com/Dev-Now/zakaty/issues)
3. Create a new issue with detailed information about your problem

### Reporting Bugs

When reporting bugs, please include:
- Your Windows version
- App version
- Steps to reproduce the issue
- Screenshots if applicable

## License

This project is licensed under a Custom Proprietary License - see the [LICENSE](LICENSE) file for details.

**Summary**: 
- ✅ Personal use permitted
- ❌ Commercial use prohibited
- ❌ Modification and redistribution prohibited
- © All rights reserved by the author

## Technical Information

- **Built with**: Flutter Framework
- **Target Platform**: Windows Desktop
- **Architecture**: x64

---

**Disclaimer**: This application is provided as a tool to assist with Zakat calculations. Users are responsible for ensuring accuracy of their inputs and should consult qualified Islamic scholars for guidance on complex Zakat matters.
