# 🕹️ ARKOS UTILITY
### *"High-Speed Handheld Migration Engine*

## 📖 The Story
I am a builder, tinkerer, technician, and SBC enthusiast. My journey into "The Vortex" of retro handhelds began when my kids brought home a **BatleXP G350**. I was impressed.  I quickly added an **R36S** (The Raspberry Pi of handhelds) to my collection and started the cycle of flashing OS images and testing different builds.

I soon realized that after every fresh flash, the task of copying a massive library of games back to the SD card was tedious and time-consuming. I asked a simple question: *"You know what would be nice? A script that automated this process from a master library..."*

Through a collaboration between AI contributors and myself over several weeks, that question evolved into this tool. Coming from a background in **Industrial Control Systems and Power Generation**, I am more used to **Function Block, and Ladder Logic** programming than **PowerShell**.  But, as someone who regularly tests software, I  applied that same "Industrial Logic" to bridge the gap between messy stock SD cards and the "Gold Standard" ArkOS structures we use today.

---

## 🚀 Key Features

*   **Engineered with Robocopy**: Utilizes the high-performance Windows `robocopy` engine. By using the multi-threaded (`/MT`) flag, it bypasses the single-threaded limitations of standard File Explorer, moving data significantly faster.
*   **Data-Driven Logic (Master Database)**: At the core is a 140-entry "Smart Database" that acts as a **Tag List**, defining system behavior:
    *   **OS-Specific Flags**: Tailors folder generation for **ArkOS**, **dArkOS**, or **dArkOS-RE**.
    *   **Subfolder Intelligence**: Correctly handles complex nested paths like `psp/ppsspp` or `ports/xash3d`.
    *   **Excel-Ready**: Generates 100-character wide, pipe-separated reports (`sep=|`) for easy inventory and Excel import.
*   **G350 Source (Set as MASTER)**: Automatically filters 170+ "junk" folders from stock G350 cards and safely appends them to a clean ArkOS structure.
*   **Universal Sync**: A "Safe" copy engine that only moves missing or newer files.
*   **Power Clone**: A "Brute Force" mirror that selectively makes the Target a conditional copy of the Master.
*   **Abort Kill-Switch**: Instantly Halts/Pauses the active Robocopy processes if you need to stop an operation.  You can then quit or resume.
*   **Audit**: Initiates a system audit that inventories and reports totals in the main log window and creates .txt files on Master and Target.

---

## 🛠️ Installation & Usage

1.  **Download**: Grab the `Latest.ps1` and the `Launcher.bat` files and place into a folder.  Or, simply dowload the .zip and extract.
2.  **Inspect**: I encourage you to open the files in Notepad and inspect the code for yourself before running.
3.  **Launch**: Run the `Launcher.bat` file (it handles the Administrator permissions required for Robocopy).
4.  **Configure**:
    *   Set **MASTER** (Your ROM Source).
    *   Set **TARGET** (Your SD Card).
5.  **Execute**: Select your OS Generation or Sync method.

---
## 📸 Interface Preview
<img width="2000" height="1500" alt="image" src="https://github.com/user-attachments/assets/b48e0518-ae9f-4023-ab9f-64477a851dff" />

## 🖥️ System Screenshots
Run Full System Audit
<img width="1270" height="1483" alt="image" src="https://github.com/user-attachments/assets/1ac0a507-9dec-4542-a6cf-4e2cc9de03d1" />

.txt file output format
<img width="1183" height="842" alt="image" src="https://github.com/user-attachments/assets/ec790f66-8485-46c0-97a0-dcda436b6b6e" />

## 🖼️ Dashboard in Action
<img width="1248" height="1464" alt="image" src="https://github.com/user-attachments/assets/36128580-8b05-4e09-bc5b-a7d93cf2895c" />

## 📚 Credits & Sources
This tool relies on the hard work of the handheld community:
*   **ArkOS Wiki**: Primary source for emulator folder structures and port information.
*   **Retro Game Handhelds**: Inspiration for G350 migration logic.
*   **Technical References**: Based on PowerShell `PSCustomObject` best practices and data-driven automation standards.

---

## ⚖️ License & Disclaimer
This project is licensed under the **MIT License**.

**CAUTION**: This software is in **BETA**. It performs file operations that can be destructive (specifically Power Clone). **Always backup your ROMs.** The author is not responsible for data loss or hardware issues.



## ☕ Support the Project

If you enjoy testing and debugging software, your time spent identifying issues and providing feedback and fixes is most valued.

If "The Vortex" saved you some time or made your handheld setup easier, feel free to help keep the gears turning!

* [**Support via Ko-fi**](https://ko-fi.com/kofisupporter19535)
* [**Support via Buy Me a Coffee**](https://www.buymeacoffee.com/jj1eckhardt)

