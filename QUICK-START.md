# Quick Start Guide

## Your Cloud Security Portfolio is Ready! 🎉

You now have a professional template structure to showcase your cloud security labs portfolio.

## Structure Overview

```
your-repo/
├── README.md                 # Your profile page (shows on GitHub profile)
├── labs/
│   ├── README.md            # Portfolio index (showcase all your labs)
│   ├── LAB-TEMPLATE.md      # Template to copy for each new lab
│   └── files/               # Store downloadable lab files here
│       └── README.md
```

## How to Add Your Lab to Your Portfolio

### Step 1: Create Lab Directory
```bash
mkdir -p labs/your-lab-name
```

### Step 2: Copy Template
```bash
cp labs/LAB-TEMPLATE.md labs/your-lab-name/README.md
```

### Step 3: Fill in Your Lab Details
Edit `labs/your-lab-name/README.md` and replace all the placeholders:
- Lab title
- Lab objective
- What you did (step-by-step)
- Key findings
- Tools used
- Screenshots
- Lessons learned
- References
- Lab metadata (date, duration, difficulty, platform, category)

### Step 4: Add Lab Files (Optional)
If you have scripts, configs, or other files to share:
```bash
# Create a ZIP of your lab materials
zip -r labs/files/your-lab-name.zip your-lab-materials/

# Or just copy files directly
cp your-lab-file.pdf labs/files/
```

### Step 5: Update Portfolio Index
Edit `labs/README.md` and add your lab to the "Portfolio Projects" section:

```markdown
### Your Lab Title

**Description:** Brief description of what the lab covers

**Key Topics:**
- Topic 1
- Topic 2
- Topic 3

**Links:**
- 📖 [View Lab Details](./your-lab-name/README.md)
- 💾 [Download Lab Files](./files/your-lab-name.zip)

---
```

### Step 6: (Optional) Add to Main README
If you want this lab featured on your profile, edit the main `README.md` and add it under "Featured Portfolio Projects"

### Step 7: Commit and Push
```bash
git add .
git commit -m "Add [your lab name] to portfolio"
git push
```

## What's Included in the Template

- **Lab Objective** - What you wanted to learn/accomplish
- **What I Did** - Step-by-step breakdown with phases
- **Key Findings** - Security issues found and their impact
- **Tools Used** - List of tools and technologies
- **Screenshots** - Visual evidence section
- **Lessons Learned** - Key takeaways
- **Download Section** - Link to lab files
- **References** - Additional resources
- **Metadata** - Date, duration, difficulty, platform, category
- **Navigation** - Links back to labs index and profile

## Tips for Building Your Portfolio

1. **Be detailed** - Demonstrate your expertise with thorough documentation
2. **Include screenshots** - Show your work visually to potential employers
3. **Document findings** - Highlight vulnerabilities you discovered
4. **Show remediation** - Demonstrate problem-solving skills
5. **Add metadata** - Helps organize your growing portfolio

---

Ready to build your portfolio? Start with Step 1 above! 🚀
