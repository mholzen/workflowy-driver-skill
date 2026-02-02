#!/usr/bin/env node

import { existsSync, mkdirSync, copyFileSync, chmodSync, readdirSync, rmSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { homedir } from "os";

const __dirname = dirname(fileURLToPath(import.meta.url));
const packageRoot = join(__dirname, "..");
const srcSkillDir = join(packageRoot, "skills", "workflowy-driver");
const destSkillDir = join(homedir(), ".claude", "skills", "workflowy-driver");

const action = process.argv[2] || "install";

if (action === "uninstall") {
  if (existsSync(destSkillDir)) {
    rmSync(destSkillDir, { recursive: true });
    console.log(`Removed ${destSkillDir}`);
  } else {
    console.log("Nothing to uninstall.");
  }
} else {
  console.log("Installing workflowy-driver skill...\n");

  copyDir(srcSkillDir, destSkillDir);

  // Make scripts and hooks executable
  for (const sub of ["hooks", "scripts"]) {
    const dir = join(destSkillDir, sub);
    if (existsSync(dir)) {
      for (const f of readdirSync(dir)) {
        if (f.endsWith(".sh")) chmodSync(join(dir, f), 0o755);
      }
    }
  }

  console.log(`Installed to ${destSkillDir}\n`);
  console.log("Usage:");
  console.log("  /workflowy-driver <node-id>\n");
  console.log("On first use, the skill will offer to configure project hooks");
  console.log("for Workflowy permission notifications.");
}

function copyDir(src, dest) {
  mkdirSync(dest, { recursive: true });
  for (const entry of readdirSync(src, { withFileTypes: true })) {
    const s = join(src, entry.name);
    const d = join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(s, d);
    } else {
      copyFileSync(s, d);
      console.log(`  ${d}`);
    }
  }
}
