# 📦 Bash script to build Open Source Template Projects

A minimal, well-structured bash script to kickstart your open-source Python project.

---

## 🚀 Quickstart

1. Naviagte to the folder that contains the **.sh**-file
2. Type in the following command

```bash
chmod +x dev_setup.sh
```

3. Now run the following command:

```bash
./dev_setup.sh
```


Follow the prompts to:

- Name your project
- Set up a Conda environment
- Configure the project in VSCode

---

## 🗑️ Delete Project Workflow

0. Open your terminal (type terminal in your systems explorer)
1. Naviagte to the folder that contains the **.sh**-file
2. Type in the following command

```bash
chmod +x teardown.sh
```

3. Now run the following command:

```bash
./teardown.sh
```


Follow the prompts to:

- Name your conda environment name
- Follow the other instructions

---

## 📁 Project Structure

```
project_name/
├── admin/teardown.sh
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
│   ├── exploratory/
│   └── modeling/
├── outputs/
│   └── figures/
├── models/
├── src/
│   ├── app/
│   ├── analysis/
│   ├── features_engineering/
│   ├── preprocessing/
│   ├── dataset/
│   ├── modeling/
│   └── tests/unit/
├── .vscode/
│   └── settings.json
├── requirements.txt
├── dev_setup.sh
└── README.md
```

---

## 🛠 Features

- Automated Conda + Jupyter + Git setup
- Clean Python package layout under `src/`
- VSCode-friendly with preconfigured interpreter path
- Ready-to-extend `.gitignore` for real-world use

---

## 🔧 Requirements

- [Anaconda](https://www.anaconda.com/)
- [VSCode](https://code.visualstudio.com/)
  - Python extension: [ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

---

## 📢 Contributing

Feel free to fork this repo, open issues, or submit PRs to improve this template!

---

## 📄 License

MIT License. See `LICENSE` for details.
